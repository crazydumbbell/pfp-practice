// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MintNFT is ERC721Enumerable {
    string metadataURI;
    // string타입의 metadataURI라는 변수 생성
    uint256 maxSupply;

    // 요녀석은 최대갯수를 변수화 하여고

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _metadataURI,
        uint256 _maxSupply
    )
        // 컨스트럭터는 배포할때 딱1번 실행되는 함수
        // 숫자형태로 선언
        ERC721(_name, _symbol)
    {
        metadataURI = _metadataURI;
        maxSupply = _maxSupply;
    }

    function mintNFT() public {
        require(totalSupply() < maxSupply, "No more mint.");
        // 자바스크립트의 조건문인 if와 같은역할 괄호안의 조건을 만족하면 아래 코드들이 실행
        // 불만족시 , 옆의 것이 실행
        // if문 대신 require문을쓰는 이유는 if분은 실행되는 함수라 가스비듬. require는 함수 실행전에 체크라 가스비x
        // totalSupply는 오픈재플린 라이브러리 함수(총 발행량)

        uint256 tokenId = totalSupply() + 1;
        // totalsupply는 총 발행 갯수를 불러와줌

        _mint(msg.sender, tokenId);
        // 메타데터를 바깥에서 불러올거기 때문에 함수는 여기서 끝 추가적으로 메타데이터를 불러오는 코드를 작성 안해도 됨
    }

    function batchMint(uint256 _amount) public {
        // 숫자타입의 amount를 받아봐서
        for (uint256 i = 0; i < _amount; i++) {
            mintNFT();
            // amount만큼 for문 돌려서 mintNFT함수 실행
        }
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    // 반환값의 타입을 정해줘야됨
    {
        // return metadataURI + '/' + _tokenId + '.json'
        return
            string(
                abi.encodePacked(
                    metadataURI,
                    "/",
                    Strings.toString(_tokenId),
                    ".json"
                    // 솔리디티에서 각 요소를 합쳐서 피나타 주소를 만들어야됨
                    // 그래서 encodePacked 라는 합치는함수를씀. 근데 문자밖에 안들어감.
                    // 그래서 위에 임포트 하고 .toString을 써서 숫자를 문자화함.
                )
            );
        // string()의 괄호안의 타입을 선언후 return
        // abi의 encodePacked는 안의 함수를 더해주는 역할
        // 솔리디티도 타입언어라서 다른타입끼리는 연산이 안됨
        // 이는 오픈재플린의 기능을 도움받음
        // view는 단순히 보는 함수라 가스비가 안듬

        // uint(_tokenId)는 string타입변환이 안되므로 Strings임포트후 Strings.toString()안에 담아서 적으면됨
    }
}
