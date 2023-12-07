import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import CA "mo:candb/CanisterActions";
import CanisterMap "mo:candb/CanisterMap";
import Utils "mo:candb/Utils";
import Buffer "mo:stablebuffer/StableBuffer";
import Login "login";
import Product "product";

shared ({caller = owner}) actor class IndexCanister() = this {
  /// @required stable variable (Do not delete or change)
  ///
  /// Holds the CanisterMap of PK -> CanisterIdList
  stable var pkToCanisterMap = CanisterMap.init();

  /// @required API (Do not delete or change)
  ///
  /// Get all canisters for an specific PK
  ///
  /// This method is called often by the candb-client query & update methods. 
  public shared query({caller = caller}) func getCanistersByPK(pk: Text): async [Text] {
    getCanisterIdsIfExists(pk);
  };

  /// @required function (Do not delete or change)
  ///
  /// Helper method acting as an interface for returning an empty array if no canisters
  /// exist for the given PK
  func getCanisterIdsIfExists(pk: Text): [Text] {
    switch(CanisterMap.get(pkToCanisterMap, pk)) {
      case null { [] };
      case (?canisterIdsBuffer) { Buffer.toArray(canisterIdsBuffer) } 
    }
  };


  ///login canister further

  public shared({caller = caller}) func autoScaleLoginCanister(pk: Text): async Text {
    // Auto-Scaling Authorization - if the request to auto-scale the partition is not coming from an existing canister in the partition, reject it
    if (Utils.callingCanisterOwnsPK(caller, pkToCanisterMap, pk)) {
      Debug.print("creating an additional canister for pk=" # pk);
      await createLoginCanister(pk, ?[owner, Principal.fromActor(this)])
    } else {
      throw Error.reject("not authorized");
    };
  };

  // Partition Login canisters by the group passed in
  public shared({caller = creator}) func createLoginCanisterByGroup(group: Text): async ?Text {
    let pk = "group#" # group;
    let canisterIds = getCanisterIdsIfExists(pk);
    if (canisterIds == []) {
      ?(await createLoginCanister(pk, ?[owner, Principal.fromActor(this)]));
    // the partition already exists, so don't create a new canister
    } else {
      Debug.print(pk # " already exists");
      null 
    };
  };

  // Spins up a new Login canister with the provided pk and controllers
  func createLoginCanister(pk: Text, controllers: ?[Principal]): async Text {
    Debug.print("creating new Login canister with pk=" # pk);
    // Pre-load 300 billion cycles for the creation of a new Login canister
    // Note that canister creation costs 100 billion cycles, meaning there are 200 billion
    // left over for the new canister when it is created
    Cycles.add(300_000_000_000);
    let newLoginCanister = await Login.Login({
      partitionKey = pk;
      scalingOptions = {
        autoScalingHook = autoScaleLoginCanister;
        sizeLimit = #heapSize(475_000_000); // Scale out at 475MB
        // for auto-scaling testing
        //sizeLimit = #count(3); // Scale out at 3 entities inserted
      };
      owners = controllers;
    });
    let newLoginCanisterPrincipal = Principal.fromActor(newLoginCanister);
    await CA.updateCanisterSettings({
      canisterId = newLoginCanisterPrincipal;
      settings = {
        controllers = controllers;
        compute_allocation = ?0;
        memory_allocation = ?0;
        freezing_threshold = ?2592000;
      }
    });

    let newLoginCanisterId = Principal.toText(newLoginCanisterPrincipal);
    // After creating the new Hello Service canister, add it to the pkToCanisterMap
    pkToCanisterMap := CanisterMap.add(pkToCanisterMap, pk, newLoginCanisterId);

    Debug.print("new login canisterId=" # newLoginCanisterId);
    newLoginCanisterId;
  };



//products canisters --further

  public shared({caller = caller}) func autoScaleProductCanister(pk: Text): async Text {
    // Auto-Scaling Authorization - if the request to auto-scale the partition is not coming from an existing canister in the partition, reject it
    if (Utils.callingCanisterOwnsPK(caller, pkToCanisterMap, pk)) {
      Debug.print("creating an additional canister for pk=" # pk);
      await createProductCanister(pk, ?[owner, Principal.fromActor(this)])
    } else {
      throw Error.reject("not authorized");
    };
  };



  // Partition product canisters by the group passed in
  public shared({caller = creator}) func createProductCanisterByGroup(group: Text): async ?Text {
    let pk = "group#" # group;
    let canisterIds = getCanisterIdsIfExists(pk);
    if (canisterIds == []) {
      ?(await createProductCanister(pk, ?[owner, Principal.fromActor(this)]));
    // the partition already exists, so don't create a new canister
    } else {
      Debug.print(pk # " already exists");
      null 
    };
  };




  // Spins up a new Login canister with the provided pk and controllers
  func createProductCanister(pk: Text, controllers: ?[Principal]): async Text {
    Debug.print("creating new Product canister with pk=" # pk);
    // Pre-load 300 billion cycles for the creation of a new Product canister
    // Note that canister creation costs 100 billion cycles, meaning there are 200 billion
    // left over for the new canister when it is created
    Cycles.add(300_000_000_000);
    let newProductCanister = await Product.Product({
      partitionKey = pk;
      scalingOptions = {
        autoScalingHook = autoScaleProductCanister;
        sizeLimit = #heapSize(475_000_000); // Scale out at 475MB
        // for auto-scaling testing
        //sizeLimit = #count(3); // Scale out at 3 entities inserted
      };
      owners = controllers;
    });
     let newProductCanisterPrincipal = Principal.fromActor(newProductCanister);
    await CA.updateCanisterSettings({
      canisterId = newProductCanisterPrincipal;
      settings = {
        controllers = controllers;
        compute_allocation = ?0;
        memory_allocation = ?0;
        freezing_threshold = ?2592000;
      }
    });

    let newProductCanisterId = Principal.toText(newProductCanisterPrincipal);
    // After creating the new Product  canister, add it to the pkToCanisterMap
    pkToCanisterMap := CanisterMap.add(pkToCanisterMap, pk, newProductCanisterId);

    Debug.print("new Product canisterId=" # newProductCanisterId);
    newProductCanisterId;
  };
}