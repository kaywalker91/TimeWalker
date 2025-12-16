import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/character.dart';

/// 기본 대화 데이터 (MVP - 조선시대)
class DialogueData {
  DialogueData._();

  // ============== 세종대왕: 한글 창제 대화 (sejong_hangul_01) ==============
  static const Dialogue sejongHangul01 = Dialogue(
    id: 'sejong_hangul_01',
    characterId: 'sejong',
    title: 'Creation of Hangul',
    titleKorean: '훈민정음 창제',
    description: '세종대왕이 훈민정음을 창제하게 된 계기와 그 과정에서 겪은 고뇌를 듣습니다.',
    estimatedMinutes: 5,
    rewards: [
      DialogueReward(knowledgePoints: 100, unlockFactId: 'fact_hangul_origin'),
    ],
    nodes: [
      // Node 1: Start
      DialogueNode(
        id: 'start',
        speakerId: 'sejong',
        emotion: 'thoughtful',
        text:
            '백성이 글을 몰라 억울한 일을 당해도 하소연조차 할 수 없는 것이 늘 안타까웠느니라.\n그래서 내가 새로운 글자를 만들고자 하는데... 그대는 어찌 생각하느냐?',
        choices: [
          DialogueChoice(
            id: 'c1_praise',
            text: '정말 위대한 생각이십니다, 전하!',
            preview: '세종의 결정 지지하기',
            nextNodeId: 'praise_response',
            reward: DialogueReward(knowledgePoints: 10),
          ),
          DialogueChoice(
            id: 'c1_ask_reason',
            text: '새 글자가 왜 필요한지 여쭤봐도 될까요?',
            preview: '이유 자세히 듣기',
            nextNodeId: 'explanation_branch',
            reward: DialogueReward(knowledgePoints: 15),
          ),
          DialogueChoice(
            id: 'c1_ask_opposition',
            text: '신하들의 반대는 없었나요?',
            preview: '반대 세력에 대해 묻기',
            nextNodeId: 'opposition_branch',
            reward: DialogueReward(knowledgePoints: 20),
          ),
        ],
      ),

      // Node 2-A: Praise Response
      DialogueNode(
        id: 'praise_response',
        speakerId: 'sejong',
        emotion: 'happy',
        text: '고맙네. 내 뜻을 알아주는 이가 있어 기쁘구려.\n하지만 쉬운 일은 아닐 것이야.',
        nextNodeId: 'end_node',
        // In a real scenario, this would merge back or continue
      ),

      // Node 2-B: Explanation Branch
      DialogueNode(
        id: 'explanation_branch',
        speakerId: 'sejong',
        emotion: 'sad',
        text:
            '우리 백성은 중국 글자(한자)를 빌려 쓰고 있으나, 이는 우리 말과 달라 배우기가 어렵지 않느냐.\n나는 누구나 쉽게 익혀 쓸 수 있는 글자가 필요하다고 보았네.',
        nextNodeId: 'end_node',
      ),

      // Node 2-C: Opposition Branch
      DialogueNode(
        id: 'opposition_branch',
        speakerId: 'sejong',
        emotion: 'serious',
        text: '그래... 최만리를 비롯한 많은 신하들이 강하게 반대했지.\n중국을 섬기는 예의에 어긋난다는 이유였어.',
        choices: [
          DialogueChoice(
            id: 'c2_convince',
            text: '그래서 포기하실 건가요?',
            nextNodeId: 'end_node_fail', // Example of a bad choice?
          ),
          DialogueChoice(
            id: 'c2_overcome',
            text: '그들을 어떻게 설득하셨나요?',
            nextNodeId: 'end_node',
            reward: DialogueReward(knowledgePoints: 30),
          ),
        ],
      ),

      // Node: End (Success)
      DialogueNode(
        id: 'end_node',
        speakerId: 'sejong',
        emotion: 'neutral',
        text: '내 뜻은 확고하니, 백성을 위해 끝까지 완성할 것이네.\n그대도 지켜봐 주게나.',
        isEnd: true,
        reward: DialogueReward(
          knowledgePoints: 50,
          unlockFactId: 'fact_hangul_creation',
        ),
      ),

      // Node: End (Fail/Short)
      DialogueNode(
        id: 'end_node_fail',
        speakerId: 'sejong',
        emotion: 'serious',
        text: '포기라니 당치도 않다! 다만 길이 험할 뿐이지.\n오늘은 피곤하니 그만 물러가거라.',
        isEnd: true,
      ),
    ],
  );

  // ============== 광개토대왕: 영토 확장 (gwanggaeto_conquest_01) ==============
  static const Dialogue gwanggaetoConquest01 = Dialogue(
    id: 'gwanggaeto_conquest_01',
    characterId: 'gwanggaeto',
    title: 'Expansion of Territory',
    titleKorean: '영토 확장',
    description: '광개토대왕과 함께 고구려의 기상을 드높일 정복 전쟁과 그의 천하관(天下觀)에 대해 논의합니다.',
    estimatedMinutes: 8,
    rewards: [
      DialogueReward(
          knowledgePoints: 150, unlockFactId: 'fact_gwanggaeto_conquest'),
    ],
    nodes: [
      // Node 1: Start
      DialogueNode(
        id: 'start',
        speakerId: 'gwanggaeto',
        emotion: 'determined',
        text:
            '짐은 국강상광개토경평안호태왕(國岡上廣開土境平安好太王)이라 불리기를 원하노라.\n동쪽으로는 동예를, 북쪽으로는 거란과 후연을 복속시키고, 남으로는 백제를 굴복시켰다.\n하지만 짐의 시선은 더 먼 곳을 향하고 있느니라. 그대는 고구려가 어디까지 뻗어나가야 한다고 보는가?',
        choices: [
          DialogueChoice(
            id: 'c1_limitless',
            text: '천하의 끝까지 고구려의 깃발을 꽂아야 합니다!',
            preview: '무한한 확장 지지',
            nextNodeId: 'ambition_node',
            reward: DialogueReward(knowledgePoints: 15),
          ),
          DialogueChoice(
            id: 'c1_stabilize',
            text: '너무 급격한 확장은 백성을 피폐하게 할까 염려됩니다.',
            preview: '내실 다지기 조언',
            nextNodeId: 'stability_node',
            reward: DialogueReward(knowledgePoints: 20),
          ),
          DialogueChoice(
            id: 'c1_baekje',
            text: '남쪽의 백제가 호시탐탐 기회를 노리고 있습니다.',
            preview: '백제 견제 조언',
            nextNodeId: 'baekje_node',
            reward: DialogueReward(knowledgePoints: 15),
          ),
        ],
      ),

      // Node 2-A: Ambition (Limitless)
      DialogueNode(
        id: 'ambition_node',
        speakerId: 'gwanggaeto',
        emotion: 'happy',
        text:
            '호오, 그대의 기개가 마음에 드는구나!\n고구려는 천손(天孫)의 후예. 우리가 바로 천하의 중심이니라.\n영락(永樂)이라는 연호를 쓴 것도 바로 그 때문이지. 우리는 중국과 대등한 제국임을 선포한 것이다!',
        nextNodeId: 'stele_node',
      ),

      // Node 2-B: Stability (Careful)
      DialogueNode(
        id: 'stability_node',
        speakerId: 'gwanggaeto',
        emotion: 'thoughtful',
        text:
            '일리 있는 말이다. 백성이 편안해야(平安) 나라도 강해지는 법.\n허나 평화는 강력한 힘이 뒷받침될 때만 지킬 수 있다.\n짐이 쉴 새 없이 정복 전쟁을 벌인 것은 후손들에게 넓은 영토와 안전을 물려주기 위함이었노라.',
        nextNodeId: 'stele_node',
      ),

      // Node 2-C: Baekje (Strategy)
      DialogueNode(
        id: 'baekje_node',
        speakerId: 'gwanggaeto',
        emotion: 'angry',
        text:
            '아신왕... 그 자는 짐에게 무릎을 꿇고 "영원히 노객(신하)이 되겠다" 맹세했으면서도, 왜(倭)와 결탁하여 다시 우리를 괴롭히려 하는가.\n짐은 배신을 용서치 않는다. 다시 한번 대군을 이끌고 남하하여 본때를 보여줄 것이다!',
         choices: [
          DialogueChoice(
            id: 'c2_rescue_silla',
            text: '신라 또한 왜의 침략으로 고통받고 있다고 합니다.',
            preview: '신라 구원 제안',
            nextNodeId: 'silla_rescue_node',
             reward: DialogueReward(knowledgePoints: 25),
          ),
        ],
      ),

      // Node 3: Silla Rescue path
      DialogueNode(
        id: 'silla_rescue_node',
        speakerId: 'gwanggaeto',
        emotion: 'determined',
        text:
            '그렇다. 내물마립간이 구원을 요청해왔지.\n짐은 보병과 기병 5만을 보내 신라를 구하고, 내친김에 왜구들을 임나가라까지 추격하여 섬멸할 것이다.\n이로써 한반도 남부 또한 고구려의 영향력 아래에 두는 것이 짐의 전략이다.',
        nextNodeId: 'end_node',
      ),

      // Node 4: Stele / Legacy (Converged path)
      DialogueNode(
        id: 'stele_node',
        speakerId: 'gwanggaeto',
        emotion: 'neutral',
        text:
            '짐이 죽은 뒤에도 이 업적이 후세에 길이 남기를 바란다.\n거대한 비석을 세워, 우리가 어떻게 영토를 넓히고 백성을 편안케 했는지 기록하게 하라.\n그 비석이 서 있는 한, 고구려의 기상은 영원할 것이다.',
        choices: [
           DialogueChoice(
            id: 'c3_promise',
            text: '폐하의 위업을 역사에 영원히 새기겠습니다.',
            preview: '기록 약속하기',
            nextNodeId: 'end_node',
            reward: DialogueReward(knowledgePoints: 30),
          ),
        ]
      ),

      // Node: End
      DialogueNode(
        id: 'end_node',
        speakerId: 'gwanggaeto',
        emotion: 'determined',
        text:
            '좋다! 이제 출정의 북소리가 울리는구나.\n그대도 짐의 뒤를 따르라. 새로운 역사가 쓰여지는 현장을 목격하게 될 것이다!',
        isEnd: true,
        reward: DialogueReward(
          knowledgePoints: 50,
          unlockFactId: 'fact_gwanggaeto_conquest',
        ),
      ),
    ],
  );

  static List<Dialogue> get all => [sejongHangul01, gwanggaetoConquest01];
}
