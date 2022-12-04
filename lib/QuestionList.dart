import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/provider_data.dart';
import 'package:provider/provider.dart';

class QuestionList extends StatefulWidget {
  final dynamic document;

  QuestionList(this.document);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document['name'],
            style: const TextStyle(
              fontSize: 18,
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }
}

Widget _buildBody() {
  final firestore = FirebaseFirestore.instance;

  return StreamBuilder(
    stream: firestore.collection('Question').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final docs = snapshot.data!.docs.where((el) {
        return el.data()['class_id'] == context.read<LectureData>().lecture_id;
      }).toList();
      return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return _buildListItem(context, docs[index]);
          });
    },
  );
}

Widget _buildListItem(BuildContext context, document) {
  var question = document.data();
  return InkWell(
    onTap: () {
      // context.read<LectureData>().set_question_id(document.id.toString());
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Container(),
      //     ));
    },
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(
                question['image_url'] == ''
                    ? 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISDxUSExMWFhUVGBgZFxcYGBkaGRgWGRgXFxsYGBsYHSggGCAlGxoYITEjJSkrLi4uGh8zODMtNygtLisBCgoKDg0OGxAQGy0lICYtLTAvLS8uLS0tLy0vLS0tLS0vLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAOEA4QMBIgACEQEDEQH/xAAcAAEAAgMBAQEAAAAAAAAAAAAABQYBAwQCBwj/xABFEAABAwIEAwUEBgcGBgMAAAABAAIDBBEFEiExBkFREzJhcYEiUpGhFDNCscHRI2Jyc7Lh8AcVNENjkhZTgqPS8TVUdP/EABoBAQACAwEAAAAAAAAAAAAAAAADBAECBQb/xAA1EQACAQIDBQYFBAEFAAAAAAAAAQIDEQQhMRJBUXHwBWGBkbHREyIyocEUM0Lx4QYVNFOC/9oADAMBAAIRAxEAPwD6ESvN0KKQ6wul0RALpdEQC6XREAul0RALpdEQC6XREAul0RALpdEQC6XREAul0RALpdEQC6XREAul0RALoiIAUQogCIiAIiIAiIgCIiAIiIAiIgC1VdTHEwvke1jRu57g0a7albVVpYW1uJOa8B8FG0DKRdrqiQa3B0dlbpbkfNZyScnouvuyOrPZWWvX4LPFI1zQ5pDmkXBBBBHUEbr0qxwxEIa6tpo/qWdi9rOUb5GkuDfA2BtyVnRrhwT80n+RSntxvz+zaCIiwSBERAEREAREQBERAEREAKIUQBERAEREAREQBERAERYa4HYg+SAyiIgOTGMQbT08k7to2k26nZrfU2HqojAGCiw4zTmznZp5jzL3628+63zWjFXfTa1lK3WGnIkqDyc8fVxePUj8QvfEDBPX0tLIf0VnzOadpHMsGM8QDckc1icVJqlxzfJaLnv8inUm5Sut2S5vXyOjg6ke2B08otLVPMrx7oPcZ6NtpyuVPLJWFtKW07lqEdiKiERFg2CIiAIuLGcVjpYXSybDQNHee47NaOZP5lVmtfiMcDq58oaWWeaTKMgi5sLt89tb8iD6bKKyu7XyXeyKpWUMteW5FzReYZQ5rXDZwBHkRcL0tSUIiIAiIgBRCiAIigOIKuZ1RBSQP7J0oe+SWwcWxsto0HS7ibX5LaMdpms57KuT6KnPxTEqaKR0sUUkcBdmkc7I+ZoOjmNboDa2/wAyrdDIHNa4bOAI8iLrMoOJrCopbmuZ7REWhIEXionbG0ve4NaNS5xAA8yVXKnH31THxUMEk2Zrm9sf0cLbgtuHv75G9gFvGEpaEVWtCmryZyTVMmIvc2N7o6NhLS9hs+ocNw08o/Hn92cGoWUmJiKFuSKanJLRc/pI397U+6T8VuwzhStZDHHJWxwMY22SGMEnxL5OfPQLcODqXMHyVVXK8XALpSLA7gZWiw8LroNQ2HCJ5pYmosSq1SSst19xZbKvY9jL+0+iUgz1Lu8d2wNO73nYHoPLwBw7hLDz3mzO85pf/MLSeDML/wDrPPnLLv176gjhuN/L/OZdqdsU2rRy8fTLIlcDwllJCImm5uXPee8957z3eJ+6yj8dqsMmHZ1MsDi3YZxmaedi03by08lo/wCDMM5Unxmm/wDNbm8MUA2pI/Uvd/E5RR7Pe1tubvxyTv5sgfatJLZUcvF/hFZOI0UFTB9CqHj9IBNnkf2PY/auZDqQNrX+NlZ5eNaS5bEZKhw+zDG53zIDfmtsWCUrTdtNAD17Jl/iRddzWgCwFh0Ct/pYv6m3zav4uxEu2ZQTVOK68ysYxPiU8bpWgUzYrSMivmkkLCHAPI0A07voVa8JxFlRTxzs7sjQbdDzafEG49FrIVd4fm+iVrqV2kVQS+Ho2Ud9ngCLEfDmsV6C+HeK09CXs3tOc8Q4Vn9WnNbvIuK8TzNY0veQ1rQS4nYAaklZmlaxpc4hrWi5JNgANySdlU3Odib+baCN1yTdpqXN19IwRv4de7z8ktqWSWr/AAu9nfq1NlW3vRdbkbcIjdXVArZQRDGSKWM8+s7h1PL+QJcTVRqn/wB3QG7n2+kPG0MQNyCfedawH5rElfNXOMNGeyp2nK+pA3toWU48tM3LlyvO4RhMNLH2cTbDck6uc73nHmVhRe38Seq0jw5998+N9e+tGDqZbnq+PLrTQ7WMAAA0AFgPAaIiIXgiIgCIiAFEKIAq5jjuyxGimPdf2kDj4vAcwergVY1F8T4YamlfG02kFnxnpIw5m68r7eq3ptKWfLzI6qbjlrr5ZkdWYZU1shZUAQ0rH/VNcHPnyu9kvcNGsNgcu/XWxFlCjeHcVFVTMl2cRaRvuyN0c0jlr8iFJJNv6XuMU4xttJ3vvCiMaxwQvbDEwzVLx7ELd7e887Mb4n+Y88QYu+NzKenaH1U3cbyY3nLJ0aNfMhbcIwxlGxwa7tJ5NZp3d57vwA5N5eJUtKjtZvy63csyljsfGgrLXr7nJDw4HOE2IvFRINWwD6iPyYe+fF2/jZTT6t1rNs1o0AGlguclVnF+NaaCUxHPI5ps7IAQ09Lki58Ar8aSXX4PL1K9atLf13/0XHC6QTSZXOI0J8Tt181txTCzD7QOZp58x5/mozDK8EMniNwQHNPUHkenRWjE62N9MSHD2gLDne45eChqzqQqRto8iShTpTozUspK7v15FZREaLmw3KtFEIp+m4eFryON+gtp6ndYqeHha8bjfoba+vJV/wBXSva5c/QV9m9vC+ZAohCKwUwoPijDO2jsDlcCHMeN2SN1a4dFOLXNHmaR/V1lOxrO9rx1Wa5lawaCTE7vrJBlhfldSsBa3O37UvN19wBp8wpnjCjlfRdlAwkZmB7GENcYQfaazkNLC3S48FW8XfLSSGsgAJy5JmEHK4fZeQNbtPy9VNQU+JFjZo6yCbMA4RmINjIOvsvb7W211ycTh6kKqkmrLNJ3tyyX3duZ6rA4qOLo7ST2n9Wl+u5GabiAxsbHHhtY1rRYNEbQAB09pd2GcQslm7B8M0EhaXNbKzLnaN8pBINlyDiaWPSooKlrusTRMz/c06eS1Una1ldBUmCSGGmbJl7UZZJHyNDD7G4aAL3US223txss873ztlvafgdCNWV0k/C1svItKIiwXAiIgCIiAFEKIAiIgKxiVPJRVDquBhfDJrUwt3B/50Y69Rz+bZObiCnFG6ra8Pia2+m5PJljs4kgWPVSio2K8PR1GJmOnIgMUYmnka3M3tc14g6MnKTu46aglTwSqNKW7f3cH7+BUxE3h4ua04d73r1aJ7hygfCx1TPrV1VnP/02fZib0AFvXrZSv0GS18v3X+F7qEoajFWvLjDT1VhoWSGF3mQ4FoO+ys+BV1RK1xqKU0xBGUGVkmYHcgs2t49VYqVZUslbvz+1u44VHCRxV6lSTz0t6t21vuILFJHMglc0e21jyB+sGkj5r4Xe/jf5lfoHFsRiNYacAiRsbZHXAylrnFotrckEa6cwoOl4YpI5e1ZC0Pvcakhp6taTZvoNOStUp7UVKxRklhqkqbz668bnvhejdDRQxv0cG3I6FxLrel7eilVprKgRsL3XsC0G24zODb+Qvc+AK1ywBt3do5ttyXXb6h2i3KUm29q2p1L3BJle13ukH4G60wvzNBuDfmDcHxC9rDV8gnZ3RZH8Qx20a4npoPndcU2PyHugN+Z+enyUQvn3FnGsrZnQ0xDQw5XPsHEuG4GYEAA6baqvHCUlu8y8sXiKrspW5ZH0ElFV+BuIn1cb2y27SO13AWzNdextyNwfkrQrBSnFxdmERENSPxCHW9tHb/14qAw/FzhzzA5j5YJDenDAC5rydYtSNDe49d76W2aPM0j+rqt4zQdtC6PZ27Dza9urSOmv4rMoRqQ2ZDDYqeDr7cXk9eu7U7TxHW/Zw15HK9RG0+otouvCuIjJMIJqd8ErmlzA4tc14buGubuQNdlz4Di4mpGzSENLQRLfQNezR1+nXyIWrhmM1NQ+vcCIwDHTA6exf2pbfrHQeCp1qNKMG0j0eAx2Lr19iVrLXLQtKIoeDiikfP2DZgX3I2OUuG7Q+2Un1VBRb0R35TjG13qTCLnpK6KW5ikZJlNjkc11j0OU6LoRqxsnfQIiLABRCiAIiIDKrXB5zU01Ue9WTveDax7KMljG+lj8VKcR1Bjoqh43bFIR55Tb5rmwiHs6Smj9yGMH9otDj8yrmFjq+sjh9t1NmnGPHr0uSNJUGN19+RHgpUYnHa+b0tr+ShEVmpQhUd2cPD46tQi4wtbv/tGvFcGFfUMc2R0EzMwilaASNzle06PaddPnveo4/wASVOHz/R5nU1S4bmIva5vTtAQWtcd7C/zF7rDKWuDmmxHPzFl8BmmL3Oed3kuPm4kn5lbwg08n8ttOsyWnONaL+Iryvrz3Iv8AF/aOw6SUxAO9nh3yLQu2fiHDq5gimc5gzB2V+ZguLjVzDl5ncr5iilsPgwvdZcmfdqKKNsTWxZezAAblNxbwPNb18RwrGZ6Z14ZC3q3dp82nT13V4wTj4SezNC4OAuXRAvaAN3FveaPisNWK88PNaZ+pdgvhuMUzoqiRj9HB7r35gkkHyI19V9epuJKOQXbUxerw0/B1itMOJUlTUdm1rZnMbm7QMDmM1FhnPM7i3QpoYpSlTvdMhv7NcKfHE+Z4I7XKGA75G39r1J08r81c130mGlwzONgdv65L3UYVYXab+B/BQPEU1K1yeWDxFSPxdnLhvty1I1ERTFAKNrWWf56qSXLiDfZB6H71tF5kVeN4MquG4NDJiUkM2cxvaJ2R5iI3PvlfnaO8b2PxuvoLWgAACwGgA2AHIKj1b+zrqKXb9I6I+Ila6wPq0q8rnY1NVD2HYNRVMInvWTPFSwuY5rTYlrgD0JBAVSwDCYKzCIIXtLQw+0G2DmyMcQ7cGxdrfnZyuCqdfJ9Dmljpj2k9Y4PZBYZYnWIfM48mnfXm3pe0FNvRa5NeHWp0qyX1S0s0/Hq1hR0cLMXDKZjWNigInyCzbuI7NpA3dpmvuR5K2KM4ewcUsOXMXyPJfLId3yHc+XQfjdSa1qSu8uut3cb0ouKzVr524d3v3hERaEgKIUQBc9fiEMDc00jIwdszgL+V9/ReMYxFlNTyTv7rG3t1OwaPEkgeqrmC4LnP0qrAkqJNbOF2xN3bGxp0bYfO/rYo0PiZvQoY7HxwqWV29xv4hxmmqKCpbDPG9wiccrXC9hqTbeykqJ+aKM9Y2fwhRXEXDkNRC4BjWyAEse0AEG2gJG4OxHitvCVT2lBA7/Ta0+bPYPzar1KiqayPOY7G/qoxk1axLoiKU5oXxfifCnU1U9hHskl0Z5FhNxby29F9oXFiuFQ1LAyZgcAbjUgg+BGov4LJNRqbDPhpK6ocPmeLsikcOrWOP3Bfe8Gp6OnFo6aOM+8Ggk+bj7R9SVONrYz9v46feqtTEzj/AA68Ds0aVCosqi5aP72f2PzTNh0zBd0MjR1cxw+8KZ/s8xdlLicM0jw2MZxIejXRuHLXvZfgvvzqpg+1/XooTGYaScWfTxyn3iwXHk7vD0IWqryqpxcNet5tUhRo/M6i5av7Hz7F6/8AvqsywwMipozd8vZtErx+s+1wTyYD4m/K6U1MyNoYxoa0cmiw+S8UFDHBGI4mBrBsB95J1J8SuhWYRUFaOhxcRXlWldlobtpsq5i9ViFPM6ZjG1VMbXhYMs8VgASz/m3NzbfUAW3XTSYiWjK4XA26j81sqMVJFmi3ifwXNWGqKVrXX29bnoP9zw8qe03Z8N9+HCxBUWN09UXOhffe7D7L266hzTqNfRdai8V4fgqDnc0tkG0rDlkHjmG/rdcIpMQg+rmjqGD7M4LJLdA9ujj4uXUSsrHnZbM25J2vufv/AEWJaKwewfT71C/8SSM+voqlnUsAlaPVp/BeKnjClLSLy36GGS+/7KyjSdKbi7L8nJxIbRxv9yeF3weB+KvpXy3HcX7aIMjhn1kjs57cjS7OCG3PUiytj8Fq6r/GTCOI7wU9wCOkkh1d4gaeSqY1JuLbO9/p/bp0JRcXe+nu93r3Gyv4ic+Q09C0TTDvSf5MPi932j+qPHpZduA4G2nDnucZZ5NZZnd5x6D3WjkB4eC7aGijhjEcTGsYNg0W9T1PidV0Kk55Wjp69cPU78abvtTzf2XXHysERFGShERACiFEBWuMvbko6c7ST53Dq2JpdY+FyPgpdQ/Fns1VBIdhM+P1kjsPuUwuphrfDXieS7ab/U58EFXeGT2U9TSH7EnbR/u5dbDwa649VYlXeKGmGSKuaL9l7EwG7qd51PjlOvqrBzIZ3jx9d3sWJF5jeHAOaQQQCCNiDqCF6WCMIiIAiIgCIiAIiIAiIgCIiAKMx/EY4Ig6R1rmwG5cejQNSdlsxvFmU0eZwLnOOWNg7z3nZo/NcGDYM7P9KqiH1B2G7YW+5GOvU/zJyjZ0043lp931xIiopq2q7NzIGwtjkZK0zOILizUBzGgkDwU0eIaqn1rIGmPnNTlzgzxex3tW8R81NrBFxY7FR1Kcan1FrC4yphValZLgdcEzXsD2ODmuALXA3BB5hbFVuFx9Hq6iiH1dhPC33WuOV7R4B9rDxPVWlcurDYk4nscNXVakqi3hERRk4REQAohRAQ3GGHuno3hn1jCJY+ueM5hbxIuPVYwjEG1EEczdntBt0Oxb6G49FNKnzD+76o30pKl1weUM53B6Nd8B4WV3CVLfI/A4fbOEc4qrFZrXkWJeZIw5pa4AhwIIOxB0IK9Irx5grWBymkn+gyE5Dd1K882bmIn3m8vD0Csq4cZwplTEY33BBzMeO8x42c09Qo3Csacx4pauzJvsP2ZONg5p2Dtrt6/ACR/Mtpa7/f36tYEREIgiIgCIiAIiIAiIgC4sXxOOmiMkh02AHec7k1o5krXjGMx0zQXXc92kcbdXvd0aPxXDhWEyPlFVV2Mv+XENWQDw6v6uWSSMctqWnr1xGCYbI+X6ZVD9KRaOPcQMPIfrHmVPoiwayld3CIsE21KGpDR2/vlltxSOLv2TLYfO6tCrHCIM81RW/ZkIih/dR7uHg59/grOuXiWnUZ7XsynKnhoqXVwiIoC+EREAKIUQBaqylZLG6ORocxws5p5j8PPktqIgym9pLhpDJi6SkJtHNa7oejJbbt5B3/oWGKRrmhzSHNIuCDcEdQRupB7A4EEAgixBFwQeRB3VXn4dmpnGSgeA0m7qaQkxk8+zdvGfl6Cyv0sVfKfmeex3Y9250PL2JtcuI4fFPGY5WB7TyPI9QdwfEKLg4niDhHUtdTS+7KPZPi2TuuHjopsStLc4ILbXuDcW8wrh5+cJ03aSaZyYRh5gYWdrJI2929oQS1th7N7XIHiu5RvDle+opI5ngNc8EkNva2YgWv4AKSQxO+076hFthpnv7rCfIG3xW52GzD/LPwv9y1c4p2bRlU5tXUX5M5EWXNINiCD0OiwtjUIiIYCr1ZxC6R5homiaQaOkP1Ef7Th3j4D+SzV4LPUyO+kTWgucsMN2528u1edTpu0aKapaVkTAyNoY0bNaLBDfJLi/t11cjsHwJsLjLI4zVDu9K7f9lg+w3wH8lLoiGG23dhEXDiuLw0zc0rw2/dbu5x6NaNShhJvQ7lW6yd1fIaWA2gabVE42I5wxnmTzOwHzjsZxOSTJ9K7Smp5LkRMGaokY0Xc6S31TANxvvodxJx1P0i1HhxEVOxo7Wdg2DtckfV55u3GvPeCrVaXy+e5e/gdrA9nLa2q27+O/x7izU8sEZbTsdG1zW2bEHDMGtHJt72A5rqVL4jwCGkpPpFOy0tO9kmckl77OAeHuOpBBJI2V0Y8EAjYi48iufKKtdHpISd3GSs1w4BERRkoREQAohRAEREAREQGupp2SNLJGNe07tcA4fAqp8RcK0sNNPPCJIXNje79FI5rXENNgW3IsTpYWVwUDx9LlwyoPVrW/7ntb+KlpSkpJJkOIhBwbkk8n6GOHIslFTtO4hjv55QT81ccKwcAB8guTs07Dz6nwUVw7SB0jGnZjRf8A6QB99ldFYxdZr5I+J5fs/DKd6s1vy9+u8wFlEXOOwaZoGvFnNBHiFBYlgeUF0VyObefp18lY0UlOrKm/lfsQV8PTrK0l47/MoKwp3iDD7fpWjT7Q/H81BLr0qiqR2keer0ZUp7Ev7QRFX+Ny4UzXiR8bWyx9o6Nxa7sycjtR+0D6BSGkI7UlHiTdRUsjGZ72sHVxDR8SoaXiynzFkPaVDx9mFhf89vmu6m4NomOzGLtXe9K50hPo42+SnIYmsbla0NA5NAA+AVOWMj/FHfp9hf8AZLyKuIsSqOTKOM8yRLMR4Aey311CksH4agp3doA6SY7zSnO8+RPd9FMLKrVK855N5HWoYGhQ+iOfF5sreCs7TEqyZ2pj7OBn6rQ3O74uN1K0kFPTARMyR9o5zmsuAXOOpygnXyGwAGwVYrsTdR4lO2JhmdVMje2NpHsytGT2/daW+0T/AOxHYxhb2iKed/aVUtRAAR3YwH3DIx0Hz+JMsaDnnorL04EFXGwoNQavJyf3f9Fr42Lv7una1rnOe0Na1oLiS5wGw101Pos4BjcU1oA2VkkcbSWSxljsos3ML7i6mZZA0FziGtAJJJsABuSeQVb4YcaipnrrERvDYYLixMTCS5/k5+o8ioY2cHdFyeVRWeu7uV3f0LKiIoicIiIAUQogCIiAIiIAq5/aAL0Dm+9JCP8Aut/JWNV3jz/CM/fwfxhSUf3I8yHE/sy5MuXC7dZD+yP4lYVXOF3+1IP2T94/FWNMV+6/D0OHgP8Ajx8fVhERVy4EREBrkYHNLTqCLHyKpFTCWPcw/ZJH5H4K9qq8SR2mv7zQfUEj7rK5gp2m48fwc3tOmnTU+D9f82Ipc2I0bZoXxO7r2lp8L8x4g6+i6UXTOIRPCuMGwo6g5amIZRfTtmDRr2E964GvO4PpZFCYphMNQ3LNGHAbHZw8nDUKN/4WZt9JrA33e3dl8rKnUwibvF2PQ4ftxRglUi2+KLBimLwUzc00rWeBPtHyaNT6BQEuLVdZ7NMw00J3nlHtuH+lHy8z15FdOH8OUsLs7IgX7533e6/W7r29FKrenhYRd3n1wIMR21UmrUls9+8jsHwaKmaQwEudq+RxzPeernc9eSh8bElRXU8MJYHRZp7vBLRl9hpIGp1Lh8FPYjVtjYSTawJJ6NG5XDwTSuc2SseCHVBGQH7MDdGeWbV3wUtaexTb3vLrwKfZlF4jFJvSObffuPZ4clncDW1BlYCCIY29nFce9b2n69VY42BoDWgAAAAAWAA2AHJZRcqUnLU9nGCjmgiItTYIiIAUQogCIiAIiIAq7x+bUOb3ZYT/ANxv5qxKB49hz4ZUDo0O/wBj2v8AwW9J2nHmRV1elJdz9CfwSoyTi+ztD67fOyuC+eU8mZjXD7TQfiLqz4ZjcRyRSSNbK64a1xAMlhcloPeNt7KzjKT+teJ5fsyulelLmvz7k4iIuedcIiIAq1xQf0jP2T96sqp2NVGedxGw9kem/wA7q1g1epfuKHaUkqNuLXucKIi6pwAiLXJM1u59OaBtLU2LnqKkN0Gp+7zUbi2ORxNu94YOXvHyA1Poo6lw6pru8HU9Kd76TSjoR/ltP9Xvok4wV5s2w9CtipbNFf8ArcjxHEcRnMTSfo0bgZpB/muGoiYemxJH5XvbWgAACwGgA2A6BaaKkjhjbHG0NY0WDRy/M8781vXKr1nVlfduPa4DBQwlLYjrvfFhERQl0IiIAiIgBREQ1CIiAIiIAo7ib/A1H7mT+ArCLMfqXNeqMS+lmnBP8LB+6j/gaoXjH66h/wD1R/xsRF1meJp/urn7n2ErCIuKemCIiGAqKERXcH/Lw/JyO1NYeP4CIiunLMhRL9z5oikplXE6LxKRhn/zLP3n4FfWiiLnYv6/A9v2Z+z5eiMLCIqp0AiIgCIiAIiID//Z'
                    : document['image_url'],
                width: 100,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(question['title'],
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height:10),
            Row(
              children: [
                Text(question['commenting'].substring(0, 30),
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const Text('...')
              ],
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(Icons.comment_outlined),
              Text(
                question['comments'].length.toString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
            ]),
            const SizedBox(height:10),
            Row(
              children: [
                Text(question['timestamp'].toDate().toString().substring(0, 10),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
              ],
            )
          ],
        )
      ],
    ),
  );
}
