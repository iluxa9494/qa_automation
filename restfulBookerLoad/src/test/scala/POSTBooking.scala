import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._

class POSTBooking extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")

  //scenario
  val scn = scenario("post booking scenario")
    .exec(http("create booking request")
      .post("/booking")
      .body(RawFileBody("src/test/resources/request bodies/createBookingPOST.json")).asJson
      .header("content-type", value = "application/json")
      .check(status is 200))

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}