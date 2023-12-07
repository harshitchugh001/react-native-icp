import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type AutoScalingCanisterSharedFunctionHook = ActorMethod<
  [string],
  string
>;
export interface Login {
  'getPK' : ActorMethod<[], string>,
  'login' : ActorMethod<[userlogin], string>,
  'signUp' : ActorMethod<[UserInfo], string>,
  'skExists' : ActorMethod<[string], boolean>,
  'transferCycles' : ActorMethod<[], undefined>,
}
export type ScalingLimitType = { 'heapSize' : bigint } |
  { 'count' : bigint };
export interface ScalingOptions {
  'autoScalingHook' : AutoScalingCanisterSharedFunctionHook,
  'sizeLimit' : ScalingLimitType,
}
export interface UserInfo {
  'userName' : string,
  'userEmail' : string,
  'userPassword' : string,
  'userConfirmPassword' : string,
}
export interface userlogin { 'userEmail' : string, 'userPassword' : string }
export interface _SERVICE extends Login {}
