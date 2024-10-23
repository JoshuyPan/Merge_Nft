module nftmerge::game {

    use sui::table::{Self, Table};
    use std::string::{String};

    use nftmerge::user::{Self, User};
    use nftmerge::nfts::{Self, NFT};

    public struct GameChecker has key {
        id: UID,
        addressPerUser: Table<address, User>,
        userNftCount: Table<address, u64>
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object( GameChecker {
            id: object::new(ctx),
            addressPerUser: table::new(ctx),
            userNftCount: table::new(ctx)
        }
        )
    }

    public entry fun register_new_user(
        game: &mut GameChecker,
        username: String,
        ctx: &mut TxContext
    ){
        let isRegistered = game.addressPerUser.contains(tx_context::sender(ctx));
        assert!(isRegistered == false);

        let user = user::create_user(username, ctx);
        game.addressPerUser.add(tx_context::sender(ctx), user);
        game.userNftCount.add(tx_context::sender(ctx), 0);
    }

    public entry fun mint_nft(
        game: &mut GameChecker,
        ctx: &mut TxContext
    ){
        let isRegistered = game.addressPerUser.contains(tx_context::sender(ctx));
        if(isRegistered){
            let nftCount = game.userNftCount.borrow(tx_context::sender(ctx));
            
            if(*nftCount < 6){
                let newCount = *nftCount + 1;
                game.userNftCount.remove(tx_context::sender(ctx));
                game.userNftCount.add(tx_context::sender(ctx), newCount);

                let nft = nfts::create_nft(ctx);
                nft.transfer_nft(tx_context::sender(ctx));
            }else{
                abort(0)
            }
        }else {
            abort(0)
        }
    }

    public entry fun merge_nfts(
        game: &mut GameChecker,
        nft1: NFT,
        nft2: NFT,
        ctx: &mut TxContext
    ){
        assert!(nft1.get_nft_isMutable());
        assert!(nft2.get_nft_isMutable());

        let isRegistered = game.addressPerUser.contains(tx_context::sender(ctx));

        if(isRegistered){
            assert!(nft1.get_nft_owner() == tx_context::sender(ctx));
            assert!(nft2.get_nft_owner() == tx_context::sender(ctx));

            let nftCount = game.userNftCount.borrow(tx_context::sender(ctx));
            let newCount = *nftCount - 1;

            game.userNftCount.remove(tx_context::sender(ctx));
            game.userNftCount.add(tx_context::sender(ctx), newCount);

            let newNFT = nfts::merge_nfts(nft1, nft2, ctx);

            let user = game.addressPerUser.borrow_mut(tx_context::sender(ctx));
            user.add_user_merged(1);
            newNFT.transfer_nft(tx_context::sender(ctx));
        }else{
            abort(0)
        }
    }
    


}