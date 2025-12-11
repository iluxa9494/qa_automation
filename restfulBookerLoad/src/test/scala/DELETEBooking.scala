import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._

class DELETEBooking extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")

  //scenario
  val scn = scenario("delete scenario")
    .exec(http("delete booking request")
      .delete("/booking/1")
      .header("Content-Type", value = "application/json")
      .header("Cookie", value = "token=abc123")
      .check(status is 403))

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}