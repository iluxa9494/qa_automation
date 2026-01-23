package simulations

import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._
import scala.concurrent.duration._
import scala.language.postfixOps

class GETBookingFixedDurationLoadCheck extends Simulation {

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

  //  Controlled duration + pauses to avoid excessive load/logs/results growth
  val scn = scenario("get booking requests fixed duration load")
    .during(1.minute) {
      exec(getBookingRequest())
        .pause(200.millis) // tune 100-500ms depending on target load
    }

  //  Stable load profile (instead of forever + burst ramp)
  setUp(
    scn.inject(
      nothingFor(5.seconds),
      constantUsersPerSec(20) during (1.minute) // tune to desired throughput
    ).protocols(httpConf)
  )
}