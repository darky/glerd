import Dict from "../gleam_stdlib/dict.mjs";
import { CustomType, Result, List } from "../prelude.mjs";

export const recordToDict = record => {
  let resp = Dict.new();
  const keys = [];
  for (const [key, val] of Object.entries(record)) {
    keys.push(key);
    const isCustomType = val instanceof CustomType && !(val instanceof Result);
    resp = resp.set(key, isCustomType ? recordToDict(val) : val);
  }
  resp = resp.set("__record_keys", List.fromArray(keys));
  resp = resp.set("__record_name", record.constructor.name);
  return resp;
};
