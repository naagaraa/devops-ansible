import http from "k6/http";
import { sleep } from "k6";
export const options = {
  stages: [
    { duration: "30s", target: 50 },
    { duration: "30s", target: 100 },
    { duration: "30s", target: 200 },
    { duration: "30s", target: 300 },
    { duration: "30s", target: 0 },
  ],
};

export default function () {
  // http.get("http://192.168.1.30/");
  http.get("https://api.hiragispace.my.id");
  // sleep(1);
}

// k6 run test.js
