contract Counter {
    use dep::aztec::{
        context::{PrivateContext, Context},
        note::{
            note_header::NoteHeader,
            utils as note_utils,
        },
        state_vars::map::Map,
    };
    use dep::value_note::{
            balance_utils,
            value_note::{
                ValueNoteMethods,
                VALUE_NOTE_LEN,
            },
    };
    use dep::easy_private_state::easy_private_state::EasyPrivateUint;

    struct Storage {
        counters: Map<EasyPrivateUint>,
    }

    impl Storage {
        fn init(context: Context) -> pub Self {
            Storage {
                counters: Map::new(
                    context,
                    1,
                    |context, slot| {
                        EasyPrivateUint::new(context, slot)
                    },
                ),
            }
        }
    }

    #[aztec(private)]
    fn constructor(headstart: u120, owner: Field) {
        let counters = storage.counters;
        counters.at(owner).add(headstart, owner);
    }

    #[aztec(private)]
      fn increment(owner: Field)  {
        let counters = storage.counters;
        counters.at(owner).add(1, owner);
    }

    unconstrained fn get_counter(owner: Field) -> Field {
        let counters = storage.counters;
        balance_utils::get_balance(counters.at(owner).set)
    }

    unconstrained fn compute_note_hash_and_nullifier(
        contract_address: Field,
        nonce: Field,
        storage_slot: Field,
        preimage: [Field; VALUE_NOTE_LEN],
    ) -> [Field; 4] {
        let note_header = NoteHeader::new(contract_address, nonce, storage_slot);
        note_utils::compute_note_hash_and_nullifier(ValueNoteMethods, note_header, preimage)
    }
}
