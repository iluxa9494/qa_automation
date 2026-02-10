import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._

class PATCHPartialUpdateBooking extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")

  //scenario
  val scn = scenario("patch update scenario")
    .exec(http("partial update booking request")
      .patch("/booking/1")
      .body(RawFileBody("src/test/resources/request bodies/partialUpdateBookingPATCH.json")).asJson
      .header("Content-Type", value = "application/json")
      .header("Accept", value = "application/json")
      .header("Cookie", value = "token=abc123")
      .check(status is 403))

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}