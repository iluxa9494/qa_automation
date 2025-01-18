package simulations

import io.gatling.core.scenario.Simulation
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import scala.language.postfixOps

class GETBookingFixedDurationLoadCheck extends Simulation {
  //http conf
  val httpConf = http.
    baseUrl("https://restful-booker.herokuapp.com")
    .proxy(Proxy("localhost", port = 8888)) //using fiddler to check HTTP traffic
    .header("Accept", value = "application/json")

  def getBookingRequest() = {
    exec(http("get booking request")
      .get("/booking/1")
      .check(status.in(200 to 304)))
  }

  val scn = scenario("get booking requests fixed duration load")
    .forever() {
      exec(getBookingRequest())
    }

  setUp(
    scn.inject(
      nothingFor(5),
      atOnceUsers(10),
      rampUsers(50) during (30 seconds)
    )
      .protocols(httpConf)
  )
    .maxDuration(1 minute)
}