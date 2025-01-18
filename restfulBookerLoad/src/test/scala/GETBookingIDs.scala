package simulations

import io.gatling.core.scenario.Simulation
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class GETBookingIDs extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")

  //scenario
  val scn = scenario("get booking ids")
    .exec(http("get booking ids request")
      .get("/booking")
      .check(status is 200))

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}