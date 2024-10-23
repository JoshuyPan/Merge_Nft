module nftmerge::nfts {

    use std::string::{String};

    public struct NFT has key {
        id: UID,
        name: String,
        isMutable: bool,
        attack: u64,
        defence: u64,
        description: String,
        owner: address
    }

    public fun create_nft(ctx: &mut TxContext): NFT{
        let attack = ctx.epoch() % 500;
        let defence = ctx.epoch() % 500;
        let names = vector<String>[
            b"Racoon".to_string(),
            b"Giraffe".to_string(),
            b"Zebra".to_string(),
            b"Elephant".to_string(),
            b"Hippo".to_string(),
            b"Dog".to_string(),
            b"Cat".to_string(),
            b"Pig".to_string(),
            b"Monkey".to_string()
        ];
        let nameIndex = ctx.epoch() % names.length();

        NFT{
            id: sui::object::new(ctx),
            name: names[nameIndex],
            isMutable: true,
            attack: attack,
            defence: defence,
            description: b"Basic animal Nft that you can merge with another base".to_string(),
            owner: tx_context::sender(ctx)
        }
    }

    public fun merge_nfts(nft1: NFT, nft2: NFT, ctx: &mut TxContext): NFT{
        let nft_attack = nft1.get_nft_attack() + nft2.get_nft_attack();
        let nft_defence = nft1.get_nft_defence() + nft2.get_nft_defence();

        nft1.delete_nft();
        nft2.delete_nft();

        NFT{
            id: object::new(ctx),
            name: b"Merged Supreme Creature".to_string(),
            isMutable: false,
            attack: nft_attack,
            defence: nft_defence,
            description: b"Congratulations mate! this NFT value is 50000 ETH".to_string(),
            owner: tx_context::sender(ctx)
        }
    }

    //Getters
    public fun get_nft_name(nft: &NFT): String {
        return nft.name
    }

    public fun get_nft_isMutable(nft: &NFT): bool {
        return nft.isMutable
    }

    public fun get_nft_attack(nft: &NFT): u64 {
        return nft.attack
    }

    public fun get_nft_defence(nft: &NFT): u64 {
        return nft.defence
    }

    public fun get_nft_owner(nft: &NFT): address {
        return nft.owner
    }

    //Setters
    fun set_owner(nft: &mut NFT, new_owner: address){
        nft.owner = new_owner;
    }

    public fun transfer_nft(mut nft: NFT, receiver: address) {
        set_owner(&mut nft, receiver);
        transfer::transfer(nft, receiver)
    }

    public fun delete_nft(mut nft: NFT) {
        set_owner(&mut nft, @0x0);
        transfer::transfer(nft, @0x0);
    }
}