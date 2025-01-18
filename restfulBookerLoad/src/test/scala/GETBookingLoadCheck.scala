package simulations

import io.gatling.core.scenario.Simulation
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import scala.language.postfixOps

class GETBookingLoadCheck extends Simulation {
  //http conf
  val httpConf = http.
    baseUrl("https://restful-booker.herokuapp.com")
    .proxy(Proxy("localhost", port=8888))//using fiddler to check HTTP traffic
    .header("Accept", value = "application/json")

  def getBookingRequest() = {
      exec(http("get booking request")
        .get("/booking/1")
        .check(status.in(200 to 204)))
  }

  val scn = scenario("get booking requests")
    .exec(getBookingRequest())

  //basic load params
  setUp(
    scn.inject(
      nothingFor(5),
      atOnceUsers(5),
      rampUsers(10) during (10 seconds)
    )
      .protocols(httpConf))

  //ramp users load params
//  scn.inject(
//    nothingFor(5),
//    constantUsersPerSec(10) during (10 seconds),
//    rampUsersPerSec(1) to (5) during (20 seconds)
//  )
//    .protocols(httpConf))
}