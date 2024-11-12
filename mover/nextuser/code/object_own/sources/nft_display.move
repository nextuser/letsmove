module object_own::my_hero;

use sui::package;
use sui::display;
use std::string::{utf8,String};
public struct Hero has key,store{
    id: UID,
    name:String,
    image_url:String,
}

public struct MY_HERO has drop{}

fun init(otw:MY_HERO,ctx: &mut TxContext){
    let keys = vector[
        utf8(b"name"),
        utf8(b"link"),

        utf8(b"image_url"),
        utf8(b"description"),
        utf8(b"project_url"),
        utf8(b"creator"),
        
    ];

    let values = vector [
        utf8(b"{name}"),
        utf8(b"https://sui-heroes.io/hero/{id}"),
        utf8(b"ipfs://{image_url}"),
        utf8(b"A true hero of the sui ecosystem"),
        utf8(b"https://sui-heros.io"),
        utf8(b"unkonw sui fan"),
    ];

    let publisher = package::claim(otw,ctx);
    let mut display = display::new_with_fields<Hero>(
        &publisher,keys,values,ctx
    );

    display::update_version(&mut display);
    transfer::public_transfer(publisher,tx_context::sender(ctx));
    transfer::public_transfer(display,tx_context::sender(ctx));

}