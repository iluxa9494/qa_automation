import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._

class PUTBooking extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")

  //scenario
  val scn = scenario("put scenario")
    .exec(http("update booking request")
      .put("/booking/1")
      .body(RawFileBody("src/test/resources/request bodies/bookingUpdatePUT.json")).asJson
      .header("Content-Type", value = "application/json")
      .header("Accept", value = "application/json")
      .header("Cookie", value = "token=abc123")
      .check(status is 403))

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}