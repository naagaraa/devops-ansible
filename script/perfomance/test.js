import http from "k6/http";
import { check } from "k6";

export const options = {
  scenarios: {
    constant_rps: {
      executor: "constant-arrival-rate",
      rate: 1000, // 👈 10k RPS
      timeUnit: "1s",
      duration: "1m",
      preAllocatedVUs: 200,
      maxVUs: 1000,
    },
  },
  thresholds: {
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(95)<50"], // target <50ms
  },
};

export default function () {
  const res = http.get("http://192.168.1.30/golang/health");
  // const res = http.get("https://gateway.hiragispace.my.id/golang/health");

  check(res, {
    "status is 200": (r) => r.status === 200,
  });
}
