// restfulBookerLoad/src/test/scala/GETBookingFixedDurationLoadCheck.scala
package simulations

import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._
import scala.concurrent.duration._
import scala.language.postfixOps

class GETBookingFixedDurationLoadCheck extends Simulation {

  // CI-safe defaults (override via -Dgatling.ci.*)
  private val usersPerSec: Double =
    Option(System.getProperty("gatling.ci.usersPerSec")).map(_.toDouble).getOrElse(5.0)

  private val durationSec: Int =
    Option(System.getProperty("gatling.ci.durationSec")).map(_.toInt).getOrElse(30)

  private val pauseMs: Int =
    Option(System.getProperty("gatling.ci.pauseMs")).map(_.toInt).getOrElse(300)

  // HTTP config
  val httpConf = http
    .baseUrl("https://restful-booker.herokuapp.com")
    .header("Accept", "application/json")

  def getBookingRequest() =
    exec(
      http("get booking request")
        .get("/booking/1")
        .check(status.in(200 to 304))
    )

  val scn = scenario("get booking requests fixed duration load")
    .during(durationSec.seconds) {
      exec(getBookingRequest())
        .pause(pauseMs.millis)
    }

  setUp(
    scn.inject(
      nothingFor(2.seconds),
      constantUsersPerSec(usersPerSec) during (durationSec.seconds)
    ).protocols(httpConf)
  ).maxDuration((durationSec + 10).seconds)
}
