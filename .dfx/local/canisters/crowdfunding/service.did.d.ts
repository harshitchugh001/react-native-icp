import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface IndexCanister {
  'autoScaleLoginCanister' : ActorMethod<[string], string>,
  'autoScaleProductCanister' : ActorMethod<[string], string>,
  'createLoginCanisterByGroup' : ActorMethod<[string], [] | [string]>,
  'createProductCanisterByGroup' : ActorMethod<[string], [] | [string]>,
  'getCanistersByPK' : ActorMethod<[string], Array<string>>,
}
export interface _SERVICE extends IndexCanister {}
