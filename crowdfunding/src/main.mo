actor {
  stable var var_name = "";

  public shared func greet(name : Text) : async Text {
    var_name := name;
    return "Hello, " # name # "!";
  };

  public query func get() : async Text {
    return var_name;
  };
  public func get1() : async Text {
    return var_name;
  }
};
