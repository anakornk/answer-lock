pragma solidity ^0.4.24;

contract AnswerLock {
    bytes32 public salt;
    bytes32 public hash;
    address public winner;
    uint256 public winnerSubmitTime;
    mapping( address => bytes32 ) public submittedHash;
    mapping( address => uint256 ) public lastSubmitTime;
    constructor(bytes32 _salt, bytes32 _hash) public {
        salt = _salt;
        hash = _hash;
        winnerSubmitTime = now + 365 days;
    }

    function submitHash(bytes32 _hash) public {
        submittedHash[msg.sender] = _hash;
        lastSubmitTime[msg.sender] = now;
    }

    function revealAnswer(string _answer) public{
        if(winnerSubmitTime > lastSubmitTime[msg.sender] && winnerSubmitTime + 1 days > now && keccak256(abi.encodePacked(_answer, salt)) == hash && keccak256(abi.encodePacked(_answer, msg.sender)) == submittedHash[msg.sender]){
            winner = msg.sender;
            winnerSubmitTime = lastSubmitTime[msg.sender];
        }
    }

    function test(string _answer) public view returns(bytes32) {
        return keccak256(abi.encodePacked(_answer, msg.sender));
    }
}
