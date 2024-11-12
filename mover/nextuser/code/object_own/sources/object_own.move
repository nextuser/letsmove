/*
/// Module: object_own
module object_own::object_own;
*/
module object_own::module_a{
use std::string::String;


    public struct Child has key,store{
        id : UID,
        name : String
    }

    public struct Parent has key,store{
        id : UID,
        name : String,
        child : Child
    }

    fun create_child(str: vector<u8>,ctx: &mut TxContext ) :Child {
        Child{
            id :object::new(ctx),
            name : str.to_string(),
        }
    }

    public struct Event has copy , drop{
        msg:String,
    }
    
    public fun say(child:&Child) {
        let str = b" Hello !";
        let mut msg = str.to_string();
        msg.append(child.name);
        sui::event::emit(Event{msg});
    }

    fun init(ctx : &mut TxContext ){
        let p = Parent{
            id : object::new(ctx),
            name: b"a parent of china".to_string(),
            child: create_child(b"bebe", ctx),
        };

    
        
        //orphan save in the sui network ,and owned by parent object
        let orphan = create_child(b"orphan ", ctx);
        transfer::public_transfer(orphan,object::uid_to_address(&p.id) );

        transfer::public_share_object(p);
    }

}

module object_own::module_b{
    use object_own::module_a::Child;
    public entry fun  letChildSay(child: & Child ){
        object_own::module_a::say(child);
    }
}
