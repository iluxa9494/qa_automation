package simulations

import io.gatling.core.scenario.Simulation
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class GETBooking extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")
  val csvFeeder = csv("src/test/resources/data/GETBooking.csv").circular

  //scenario
  def getBookingRequest() = {
    feed(csvFeeder)
      .exec(http("get booking request")
        .get("/booking/1")
        .header("Accept", value = "application/json")
        .check(jsonPath("$.firstname").is("${firstname}"))
        .check(jsonPath("$.lastname").is("${lastname}"))
        .check(status.in(200 to 204)))
  }

  //repeat some requests
  def getBookingRepeatRequest() = {
    repeat(2) {
      exec(http("get booking request")
        .get("/booking/1")
        .header("Accept", value = "application/json")
        .check(status.in(304)))
    }
  }

  val scn = scenario("get booking requests")
    .exec(getBookingRequest())
    .pause(3)
    .exec(getBookingRepeatRequest())

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}