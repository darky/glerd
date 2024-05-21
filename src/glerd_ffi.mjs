import { CustomType } from "../prelude.mjs";

export const isLikeRecord = (x) => {
  return (
    Object.getPrototypeOf(Object.getPrototypeOf(x)).constructor === CustomType
  );
};
