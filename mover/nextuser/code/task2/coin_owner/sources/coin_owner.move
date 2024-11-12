/*
/// Module: coin_owner
module coin_owner::coin_owner;
*/
module coin_owner::jp{
   use sui::types;
   use sui::coin;
   use sui::balance::{Supply};
   
   public struct JP has drop{}


    public struct SupplyHold has key,store{
        id : UID,
        supply : Supply<JP>,
    }

    public fun supply_immut(hold : &SupplyHold): &Supply<JP>{
        & hold.supply
    }

    fun init(otw : JP,ctx: &mut TxContext)
    {

        assert!(types::is_one_time_witness(&otw));

        let (cap,meta ) = coin::create_currency(
            otw,
            9u8,
            b"YEN",
            b"YEN",
            b"Japanese Money",
            option::none(),
            ctx
        );

    
        transfer::public_freeze_object(meta);


        let hold = SupplyHold{ 
            id : object::new(ctx), 
            supply: cap.treasury_into_supply(),
            };

        transfer::public_share_object(hold);
    }     
}