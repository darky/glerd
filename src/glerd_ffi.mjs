import Dict from "../gleam_stdlib/dict.mjs";
import { CustomType } from "../prelude.mjs";

export const recordToDict = record => {
  let resp = Dict.new();
  for (const [key, val] of Object.entries(record)) {
    resp = resp.set(key, val instanceof CustomType ? recordToDict(val) : val);
  }
  return resp;
};
