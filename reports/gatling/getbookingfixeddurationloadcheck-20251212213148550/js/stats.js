var stats = {
    type: "GROUP",
name: "All Requests",
path: "",
pathFormatted: "group_missing-name--1146707516",
stats: {
    "name": "All Requests",
    "numberOfRequests": {
        "total": "14939",
        "ok": "0",
        "ko": "14939"
    },
    "minResponseTime": {
        "total": "151",
        "ok": "-",
        "ko": "151"
    },
    "maxResponseTime": {
        "total": "921",
        "ok": "-",
        "ko": "921"
    },
    "meanResponseTime": {
        "total": "172",
        "ok": "-",
        "ko": "172"
    },
    "standardDeviation": {
        "total": "44",
        "ok": "-",
        "ko": "44"
    },
    "percentiles1": {
        "total": "169",
        "ok": "-",
        "ko": "169"
    },
    "percentiles2": {
        "total": "174",
        "ok": "-",
        "ko": "174"
    },
    "percentiles3": {
        "total": "183",
        "ok": "-",
        "ko": "183"
    },
    "percentiles4": {
        "total": "187",
        "ok": "-",
        "ko": "187"
    },
    "group1": {
    "name": "t < 800 ms",
    "htmlName": "t < 800 ms",
    "count": 0,
    "percentage": 0
},
    "group2": {
    "name": "800 ms <= t < 1200 ms",
    "htmlName": "t >= 800 ms <br> t < 1200 ms",
    "count": 0,
    "percentage": 0
},
    "group3": {
    "name": "t >= 1200 ms",
    "htmlName": "t >= 1200 ms",
    "count": 0,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "htmlName": "failed",
    "count": 14939,
    "percentage": 100
},
    "meanNumberOfRequestsPerSecond": {
        "total": "271.618",
        "ok": "-",
        "ko": "271.618"
    }
},
contents: {
"req_get-booking-req--236843778": {
        type: "REQUEST",
        name: "get booking request",
path: "get booking request",
pathFormatted: "req_get-booking-req--236843778",
stats: {
    "name": "get booking request",
    "numberOfRequests": {
        "total": "14939",
        "ok": "0",
        "ko": "14939"
    },
    "minResponseTime": {
        "total": "151",
        "ok": "-",
        "ko": "151"
    },
    "maxResponseTime": {
        "total": "921",
        "ok": "-",
        "ko": "921"
    },
    "meanResponseTime": {
        "total": "172",
        "ok": "-",
        "ko": "172"
    },
    "standardDeviation": {
        "total": "44",
        "ok": "-",
        "ko": "44"
    },
    "percentiles1": {
        "total": "169",
        "ok": "-",
        "ko": "169"
    },
    "percentiles2": {
        "total": "174",
        "ok": "-",
        "ko": "174"
    },
    "percentiles3": {
        "total": "183",
        "ok": "-",
        "ko": "183"
    },
    "percentiles4": {
        "total": "187",
        "ok": "-",
        "ko": "187"
    },
    "group1": {
    "name": "t < 800 ms",
    "htmlName": "t < 800 ms",
    "count": 0,
    "percentage": 0
},
    "group2": {
    "name": "800 ms <= t < 1200 ms",
    "htmlName": "t >= 800 ms <br> t < 1200 ms",
    "count": 0,
    "percentage": 0
},
    "group3": {
    "name": "t >= 1200 ms",
    "htmlName": "t >= 1200 ms",
    "count": 0,
    "percentage": 0
},
    "group4": {
    "name": "failed",
    "htmlName": "failed",
    "count": 14939,
    "percentage": 100
},
    "meanNumberOfRequestsPerSecond": {
        "total": "271.618",
        "ok": "-",
        "ko": "271.618"
    }
}
    }
}

}

function fillStats(stat){
    $("#numberOfRequests").append(stat.numberOfRequests.total);
    $("#numberOfRequestsOK").append(stat.numberOfRequests.ok);
    $("#numberOfRequestsKO").append(stat.numberOfRequests.ko);

    $("#minResponseTime").append(stat.minResponseTime.total);
    $("#minResponseTimeOK").append(stat.minResponseTime.ok);
    $("#minResponseTimeKO").append(stat.minResponseTime.ko);

    $("#maxResponseTime").append(stat.maxResponseTime.total);
    $("#maxResponseTimeOK").append(stat.maxResponseTime.ok);
    $("#maxResponseTimeKO").append(stat.maxResponseTime.ko);

    $("#meanResponseTime").append(stat.meanResponseTime.total);
    $("#meanResponseTimeOK").append(stat.meanResponseTime.ok);
    $("#meanResponseTimeKO").append(stat.meanResponseTime.ko);

    $("#standardDeviation").append(stat.standardDeviation.total);
    $("#standardDeviationOK").append(stat.standardDeviation.ok);
    $("#standardDeviationKO").append(stat.standardDeviation.ko);

    $("#percentiles1").append(stat.percentiles1.total);
    $("#percentiles1OK").append(stat.percentiles1.ok);
    $("#percentiles1KO").append(stat.percentiles1.ko);

    $("#percentiles2").append(stat.percentiles2.total);
    $("#percentiles2OK").append(stat.percentiles2.ok);
    $("#percentiles2KO").append(stat.percentiles2.ko);

    $("#percentiles3").append(stat.percentiles3.total);
    $("#percentiles3OK").append(stat.percentiles3.ok);
    $("#percentiles3KO").append(stat.percentiles3.ko);

    $("#percentiles4").append(stat.percentiles4.total);
    $("#percentiles4OK").append(stat.percentiles4.ok);
    $("#percentiles4KO").append(stat.percentiles4.ko);

    $("#meanNumberOfRequestsPerSecond").append(stat.meanNumberOfRequestsPerSecond.total);
    $("#meanNumberOfRequestsPerSecondOK").append(stat.meanNumberOfRequestsPerSecond.ok);
    $("#meanNumberOfRequestsPerSecondKO").append(stat.meanNumberOfRequestsPerSecond.ko);
}
