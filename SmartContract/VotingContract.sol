// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{
    uint private TotalCount=0;
    enum VoterStatus {NOT_ELIGIBLE,ELIGIBLE,VOTE_CAST_DONE,NOT_DONE_YET}
    //V_Status VotingStatus;

    enum CandidateStatus {NOT_ELIGIBLE,ELIGIBLE}
    //C_Status CandidateStatus;

    struct Voter{
        string VoterName;
        uint8 VoterAge;
        VoterStatus status;
        //address CandidateAddress;    
    }

    struct Candidate{
        string CandidateName;
        uint8 CandidateAge;
        //string Logo;
        CandidateStatus status;
        //address[] PeopleAddresses;
    }

    mapping(address=>Voter) public ListPeople;
    mapping(address=>Candidate) public ListApplicants;
    mapping(address=>address[]) public Vote;

    function isStringEmpty(string memory str) private pure returns (bool) {
        bytes memory strBytes = bytes(str);
        return strBytes.length == 0;
    }

    function isCandidateKeyInMapping(address _CandidateAddress) private view returns(bool){
        Candidate memory CandidateData=ListApplicants[_CandidateAddress];
        return isStringEmpty(CandidateData.CandidateName);
        //return CandidateData.exists;

    }

    function isPeopleKeyInMapping(address _PeopleAddress) private view returns(bool){
        Voter storage PeopleData=ListPeople[_PeopleAddress];
        //return PeopleData.exists;  
        return isStringEmpty(PeopleData.VoterName);     
    }

    function AddCandidate(string memory _name, address _CandidateAddress, uint8 _age) public {
        bool _isExists = isCandidateKeyInMapping(_CandidateAddress);
        if(_isExists==false){
            if(isStringEmpty(_name) && _age>18){
            ListApplicants[_CandidateAddress]=Candidate(_name,_age,CandidateStatus.ELIGIBLE);
            }
            else{
            ListApplicants[_CandidateAddress]=Candidate(_name,_age,CandidateStatus.NOT_ELIGIBLE);   
            }
        }
    }

    function AddPerson(string memory _name, address _PersonAddress, uint8 _age) public {
        bool _isExists = isPeopleKeyInMapping(_PersonAddress);
        if(_isExists==false){
            if(isStringEmpty(_name) && _age>18){
            ListPeople[_PersonAddress]=Voter(_name,_age,VoterStatus.ELIGIBLE);
            }
            else{
            ListPeople[_PersonAddress]=Voter(_name,_age,VoterStatus.NOT_ELIGIBLE);   
            }
        }
    }

    function isPersonEligible(address _voteFrom) private view returns(bool){
        bool _IsPersonKeyExists=isPeopleKeyInMapping(_voteFrom);
        if(_IsPersonKeyExists==true){
            return ListPeople[_voteFrom].status==VoterStatus.ELIGIBLE ? true: false;
        }
        else{
            return false;}
        
    }
    function isCandidateEligible(address _voteTo) private view returns(bool){
        bool _IsCandidateExists =isCandidateKeyInMapping(_voteTo);
            if(_IsCandidateExists==true){
                return ListApplicants[_voteTo].status==CandidateStatus.ELIGIBLE ? true:false;
        }
        else{
            return false;}

    }

    function CastVote(address _voteFrom,address _voteTo) public {
        bool _IsPersonEligible=isPersonEligible(_voteFrom);
        if(_IsPersonEligible==true){
                bool _IsCandidateEligible=isCandidateEligible(_voteTo);
                if(_IsCandidateEligible==true){
                        //ListApplicants[_voteTo].PeopleAddresses.push(_voteFrom);
                        Vote[_voteTo].push(_voteFrom);
                        ListPeople[_voteFrom].status=VoterStatus.VOTE_CAST_DONE;
                        //ListPeople[_voteFrom].CandidateAddress=_voteTo;
                        TotalCount=TotalCount+1;
            }   
        }
    }
    function getTotalCount() public view returns(uint _count){
        return TotalCount;
    }

    function getCandidateCount(address _CandidateAddress) public view returns(uint _count){
        bool _IsCandidate=isCandidateKeyInMapping(_CandidateAddress);
        if(_IsCandidate==true){
            return Vote[_CandidateAddress].length;
        }

    }

}