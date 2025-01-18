import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.http.Predef._

class GETPing extends Simulation {
  //http conf
  val httpConf = http.baseUrl("https://restful-booker.herokuapp.com")

  //scenario
  val scn = scenario("get ping scenario")
    .exec(http("get ping request")
      .get("/ping")
      .check(status.in (200 to 204)))

  //setup
  setUp(scn.inject(atOnceUsers(1))).protocols(httpConf)
}