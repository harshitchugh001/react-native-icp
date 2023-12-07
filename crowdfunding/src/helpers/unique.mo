import UUID "mo:uuid/UUID";
import Source "mo:uuid/async/SourceV4";

module {
    public func getuuid() : async Text {
        let g = Source.Source();
        UUID.toText(await g.new());
    };


    public func GetUniqueId(word:Text):async Text{
        let unique= await getuuid();
        return word # "#" #unique;
    };
};
