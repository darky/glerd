import Dict from "../gleam_stdlib/dict.mjs";
import { CustomType } from "../prelude.mjs";

export const recordToDict = record => {
  let resp = Dict.fromObject(record);
  resp.forEach((val, key) => {
    if (val instanceof CustomType) {
      resp = resp.set(key, recordToDict(val));
    }
  });
  return resp;
};
