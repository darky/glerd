import Dict from "../gleam_stdlib/dict.mjs";
import { CustomType } from "../prelude.mjs";

export const recordToDict = record => {
  let resp = Dict.new();
  const keys = [];
  for (const [key, val] of Object.entries(record)) {
    keys.push(key);
    resp = resp.set(key, val instanceof CustomType ? recordToDict(val) : val);
  }
  resp = resp.set("__record_keys", keys);
  resp = resp.set("__record_name", record.constructor.name);
  return resp;
};
