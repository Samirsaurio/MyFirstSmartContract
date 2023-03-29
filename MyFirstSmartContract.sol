// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ContratoFinal {

    enum State {Active, Inactive}

    struct Contrato{
        uint idNumber;
        State projectState; // 0 abierto 1 cerrado
        string name;
        address payable wallet;
        uint funds;
    }

    Contrato public contrato;

    //uint public idNumber;
    //uint public projectState = 0; // 0 abierto 1 cerrado
    //string public name;
    //address payable public wallet;
    //uint public funds;

    

    constructor(uint _idNumber, string memory _name) {
        //idNumber = _idNumber;
        //name = _name;
        //wallet = payable(msg.sender);
        contrato = Contrato(_idNumber, State.Active, _name, payable(msg.sender), 0);
    }

    //MODIFIERS

    modifier isAuthor(){
        require(contrato.wallet == msg.sender, "Only Author can change this");
        _;
    }

    modifier isNotAuthor(){
        require(contrato.wallet != msg.sender, "As an author you can't fund your own project");
        _;
    }

    //EVENTS

    event projectStateChanged(State state);

    event fundEther(uint projectId, uint totalTilDate); //El event es una funcion solo recibe parametros

    //ERRORS

    error cantBeLowerToZero(uint quantity);



    function fundProject() public payable isNotAuthor{
        require(contrato.projectState != State.Inactive, "This project is closed");
        if(msg.value >0)
        {
            contrato.wallet.transfer(msg.value);
            contrato.funds += msg.value;
            emit fundEther(contrato.idNumber, msg.value);
        }
        else{
            revert cantBeLowerToZero(msg.value);
        }
        
    }
    
    function changeProjectState(State _projectState) public isAuthor{
        require(contrato.projectState != _projectState);
        contrato.projectState = _projectState;
        emit projectStateChanged(_projectState);
    }


}