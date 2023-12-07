import CA "mo:candb/CanisterActions";
import CanDB "mo:candb/CanDB";
import Entity "mo:candb/Entity";
import Type "login-types";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import UserId "./helpers/unique";
import Debug "mo:base/Debug";
import Error "mo:base/Error";

shared ({caller = owner}) actor class Login({
  // the primary key of this canisterstoredUserInfo
  partitionKey : Text;
  // the scaling options that determine when to auto-scale out this canister storage partition
  scalingOptions : CanDB.ScalingOptions;
  // (optional) allows the developer to specify additional owners (i.e. for allowing admin or backfill access to specific endpoints)
  owners : ?[Principal];
}) {
  /// @required (may wrap, bustoredUserInfot must be present in some form in the canister)
  stable let db = CanDB.init({
    pk = partitionKey;
    scalingOptions = scalingOptions;
    btreeOrder = null;
  });

  /// @recommended (not required) public API
  public query func getPK() : async Text {db.pk};

  /// @required public API (Do not delete or change)
  public query func skExists(sk : Text) : async Bool {
    CanDB.skExists(db, sk);
  };

  /// @required public API (Do not delete or change)
  public shared ({caller = caller}) func transferCycles() : async () {
    if (caller == owner) {
      return await CA.transferCycles(caller);
    };
  };

  //main code


  //signup
  public func signUp(Info : Type.UserInfo) : async Text {
    let storedUser = await fetchuser(Info.userEmail);
    switch(storedUser){  
      case (?value){
        return "user is already registered";
      };
      case (null){
        if (Info.userName == "" or Info.userPassword == "" or Info.userConfirmPassword == "") {
          return " ";
        };
        if (Info.userPassword != Info.userConfirmPassword) {
          return "Password and confirm password are not the same";
        } else {

          let userId = await UserId.GetUniqueId(Info.userEmail);
          Debug.print(debug_show (userId));
          await* CanDB.put(
            db,
            {
              sk = Info.userEmail;
              attributes = [
                ("userId", #text(userId)),
                ("userName", #text(Info.userName)),
                ("userEmail", #text(Info.userEmail)),
                ("userPassword", #text(Info.userPassword)),
              ];
            },
          );
          return "User successfully registered";
        };
      };
    };
  };
  //fetch user
  func fetchuser(userEmail : Text) : async ?Type.storedUserInfo {
    let data = switch (CanDB.get(db, {sk = userEmail})) {
      case null {null};
      case (?userEntity) {unwrapUserDetail(userEntity)};
    };
    switch (data) {
      case (?value) { ?value };

      case (null) { null };

    };
  };
  //unwraperdetail of fetchuser
  func unwrapUserDetail(entity : Entity.Entity) : ?Type.storedUserInfo {
    let {sk; attributes} = entity;
    let userId = Entity.getAttributeMapValueForKey(attributes, "userId");
    let userName = Entity.getAttributeMapValueForKey(attributes, "userName");
    let userEmail = Entity.getAttributeMapValueForKey(attributes, "userEmail");
    let userPassword = Entity.getAttributeMapValueForKey(attributes, "userPassword");
    switch (userId, userName, userEmail, userPassword) {
      case (
        ?(#text(userId)),
        ?(#text(userName)),
        ?(#text(userEmail)),
        ?(#text(userPassword)),
      ) {?{userId; userName; userEmail; userPassword}};
      case _ {
        null;
      };
    };
  };
  //login user
  public func login(user: Type.userlogin): async Text {
    let storedUser = await fetchuser(user.userEmail);
    Debug.print(debug_show(storedUser));
    switch (storedUser) {
        case (?storedUserData) { 
            if (Text.equal(user.userPassword, storedUserData.userPassword) and Text.equal(user.userEmail, storedUserData.userEmail)) {
                return "Login success";
            } else {
                throw Error.reject("Invalid user credentials");
            }
        };
        case (null) {
            throw Error.reject("User not found");
        };
    }
};

};
