import AbacatePay from "abacatepay-nodejs-sdk";

const abacate = AbacatePay(process.env["TOKEN_ABACATE_PAY"] || "");

export default abacate