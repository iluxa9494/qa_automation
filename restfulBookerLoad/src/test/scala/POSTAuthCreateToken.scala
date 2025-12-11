import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._

class POSTAuthCreateToken extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")

  //scenario
  val scn = scenario("post auth create token scenario")
    .exec(http("create auth token request")
      .post("/auth")
      .body(RawFileBody("src/test/resources/request bodies/authCreateTokenPOST.json")).asJson
      .header("Content-Type", value = "application/json")
      .check(status is 200))

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}