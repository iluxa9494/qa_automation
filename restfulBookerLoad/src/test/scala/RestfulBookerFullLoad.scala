package simulations

import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._
import scala.concurrent.duration._
import scala.language.postfixOps

class RestfulBookerFullLoad extends Simulation {

  private val usersPerSec: Double =
    Option(System.getProperty("gatling.ci.usersPerSec")).map(_.toDouble).getOrElse(5.0)

  private val durationSec: Int =
    Option(System.getProperty("gatling.ci.durationSec")).map(_.toInt).getOrElse(30)

  private val pauseMs: Int =
    Option(System.getProperty("gatling.ci.pauseMs")).map(_.toInt).getOrElse(300)

  private val authUsername: String =
    sys.env.getOrElse("RB_AUTH_USERNAME", "admin")

  private val authPassword: String =
    sys.env.getOrElse("RB_AUTH_PASSWORD", "password123")

  private val baseUrl: String =
    sys.env.getOrElse("RB_BASE_URL", "https://restful-booker.herokuapp.com")

  println(s"[gatling] baseUrl=${baseUrl}")
  println(s"[gatling] auth username=${authUsername}, passwordLength=${authPassword.length}")

  val httpConf = http
    .baseUrl(baseUrl)
    .header("Accept", "application/json")

  def createToken() =
    exec(
      http("POST /auth")
        .post("/auth")
        .body(StringBody(s"""{"username":"${authUsername}","password":"${authPassword}"}""")).asJson
        .header("Content-Type", "application/json")
        .check(status is 200)
        .check(jsonPath("$.token").saveAs("token"))
    )

  def createBooking() =
    exec(
      http("POST /booking")
        .post("/booking")
        .body(RawFileBody("request bodies/createBookingPOST.json")).asJson
        .header("Content-Type", "application/json")
        .check(status is 200)
    )

  def getBooking() =
    exec(
      http("GET /booking/1")
        .get("/booking/1")
        .check(status.in(200 to 304))
    )

  def getBookingIds() =
    exec(
      http("GET /booking")
        .get("/booking")
        .check(status is 200)
    )

  def updateBooking() =
    exec(
      http("PUT /booking/1")
        .put("/booking/1")
        .body(RawFileBody("request bodies/bookingUpdatePUT.json")).asJson
        .header("Content-Type", "application/json")
        .header("Accept", "application/json")
        .header("Cookie", "token=${token}")
        .check(status.in(200 to 403))
    )

  def partialUpdateBooking() =
    exec(
      http("PATCH /booking/1")
        .patch("/booking/1")
        .body(RawFileBody("request bodies/partialUpdateBookingPATCH.json")).asJson
        .header("Content-Type", "application/json")
        .header("Accept", "application/json")
        .header("Cookie", "token=${token}")
        .check(status.in(200 to 403))
    )

  def deleteBooking() =
    exec(
      http("DELETE /booking/1")
        .delete("/booking/1")
        .header("Content-Type", "application/json")
        .header("Cookie", "token=${token}")
        .check(status.in(200 to 403))
    )

  def ping() =
    exec(
      http("GET /ping")
        .get("/ping")
        .check(status.in(200 to 204))
    )

  val scn = scenario("restful-booker full load")
    .exec(ping())
    .during(durationSec.seconds) {
      group("Auth") {
        exec(createToken())
      }.exitHereIfFailed
        .group("Booking") {
          exec(createBooking())
            .exec(getBooking())
            .exec(getBookingIds())
            .exec(updateBooking())
            .exec(partialUpdateBooking())
            .exec(deleteBooking())
        }
        .group("Health") {
          exec(ping())
        }
        .pause(pauseMs.millis)
    }

  setUp(
    scn.inject(
      nothingFor(2.seconds),
      constantUsersPerSec(usersPerSec) during (durationSec.seconds)
    ).protocols(httpConf)
  ).maxDuration((durationSec + 10).seconds)
}
