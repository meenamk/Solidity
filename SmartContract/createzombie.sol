//mentioning version
pragma solidity >=0.5.0 <0.6.0;  

//creating contract; name: ZombieFactory
contract ZombieFactory {   

    // declare our event here
    event NewZombie (uint zombieId, string name, uint dna);

    // declare uint variables and assigning values
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // declare struct called "Zombie"
    struct Zombie {
        string name;
        uint dna;
    }

    //declare array type of Zombie (struct) *see above
    Zombie[] public zombies;

    //create private function called _createZombie
    function _createZombie(string memory _name, uint _dna) private {

        //declare variable "id" type uint 
        // assigning value to id by adding values in to array "zombies"
        uint id= zombies.push(Zombie(_name, _dna))-1;

        // fire the event here
        //returning created id, received name, and dna value
        emit NewZombie(id, _name, _dna);
    }

    //create a private view function called "_generateRandomDna" which returns uint value 
    function _generateRandomDna(string memory _str) private view returns (uint) {

        //declare variable rand with type uint
        //generate the hash for given string using keccak256 
        uint rand = uint(keccak256(abi.encodePacked(_str)));

        //return the value using modulos method
        return rand % dnaModulus;
    }

    //create a public function called "createRandomZombie"
    function createRandomZombie(string memory _name) public {

        //declare variable randDna with datatype uint which holds the value of generated Dna from function "_generateRandomDna"
        uint randDna = _generateRandomDna(_name);
        
        //calling function "_createZombie"
        _createZombie(_name, randDna);
    }

}