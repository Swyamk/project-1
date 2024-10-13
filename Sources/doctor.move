module 0x1::Doctor {
    use aptos_framework::signer;
    use aptos_std::table;

    struct Doctor has copy, drop, store {
        doctor_name: vector<u8>,
        doctor_specialisation: vector<u8>,
        doctor_ph_no: u64,
        doctor_address: vector<u8>,
    }

    struct DoctorList has key {
        map: table::Table<u64, Doctor>,
    }

    struct Owner has key {
        address: address,
    }

    public fun initialize(owner: &signer) {
        move_to(owner, Owner { address: signer::address_of(owner) });
        move_to(owner, DoctorList { map: table::new<u64, Doctor>(signer::address_of(owner)) });
    }

    public fun store_doctor_details(
        owner: &signer,
        doctor_id: u64,
        doctor_name: vector<u8>,
        doctor_specialisation: vector<u8>,
        doctor_ph_no: u64,
        doctor_address: vector<u8>
    ) {
        let owner_address = signer::address_of(owner);
        let owner_resource = borrow_global<Owner>(owner_address);
        assert!(owner_address == owner_resource.address, 1);
        let doctor_list = borrow_global_mut<DoctorList>(owner_address);
        let doctor = Doctor {
            doctor_name,
            doctor_specialisation,
            doctor_ph_no,
            doctor_address,
        };
        table::add(&mut doctor_list.map, doctor_id, doctor);
    }

    public fun retrieve_doctor_details(owner: &signer, doctor_id: u64): (vector<u8>, vector<u8>, u64, vector<u8>) {
        let owner_address = signer::address_of(owner);
        let doctor_list = borrow_global<DoctorList>(owner_address);
        let doctor = table::borrow(&doctor_list.map, doctor_id);
        (doctor.doctor_name, doctor.doctor_specialisation, doctor.doctor_ph_no, doctor.doctor_address)
    }
}
