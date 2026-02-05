# TimeWalker Content Expansion Plan

## 1. Current State Analysis
*   **Three Kingdoms (Pre-668)**: Strong coverage (11 characters). Core figures like Gwanggaeto, Kim Yu-shin, and Gyebaek are present.
*   **Unified Silla (668-918)**: **MISSING**. Currently, there is a gap between the Three Kingdoms and Goryeo.
*   **Goryeo (918-1392)**: Basic coverage properties exist (Wang Geon, Seo Hui, Gang Gam-chan, Gongmin), but content depth (encyclopedia/quiz) is likely shallow compared to Joseon.
*   **Joseon (1392-1897)**: Strong coverage (6 key figures). Sejong, Yi Sun-sin, etc. are well implemented.
*   **Modern Era (1897-1945)**: **MISSING**. Critical period for modern identity.
*   **Europe (Renaissance)**: **POOR QUALITY**. Contains messy, auto-generated WikiData entries ("Q-codes") that degrade user experience.

## 2. Phased Expansion Strategy

### Phase 1: Data Hygiene (Immediate)
**Goal**: Remove low-quality data and stabilize existing eras.
*   **Action**: Delete all auto-generated "Q-code" characters from `europe_renaissance`.
*   **Action**: Consolidate Renaissance to 5-6 high-quality manually curated figures (e.g., add Michelangelo, Shakespeare to join Da Vinci/Galileo).

### Phase 2: Bridging the Timeline (Short-term)
**Goal**: Connect Three Kingdoms to Goryeo.
*   **New Era**: **Unified Silla (North-South States Period)**.
*   **Key Figures**:
    *   **Jang Bogo**: The King of the Sea (Trade/Maritime).
    *   **Choi Chi-won**: The Genius Scholar (Literature/Civics).
    *   **Wonhyo**: Buddhism for the masses.
*   **Locations**: Cheonghaejin, Bulguksa.

### Phase 3: The Modern Era (Medium-term)
**Goal**: Complete the Korean timeline.
*   **New Era**: **Imperial Korea & Independence Movement**.
*   **Key Figures**:
    *   **An Jung-geun**: Hero of Harbin.
    *   **Yu Gwan-sun**: March 1st Movement symbol.
    *   **Kim Gu**: Leader of the Provisional Government.
*   **Locations**: Seodaemun Prison, Shanghai Provisional Government.

### Phase 4: Validating Goryeo (Medium-term)
**Goal**: Flesh out the Goryeo dynasty.
*   **Additions**:
    *   **Choe Museon**: Gunpowder invention (Science).
    *   **Mun Ik-jeom**: Cotton introduction (Economy).
    *   **Sambyeolcho**: Spirit of resistance.
*   **Encyclopedia**: Add entries for Tripitaka Koreana (Palman Daejanggyeong) and Jikji.

### Phase 5: World History Expansion (Long-term)
**Goal**: Deliver on the "TimeWalker" promise of global exploration.
*   **New Era**: **Industrial Revolution (18th-19th Century)**.
*   **Key Figures**: James Watt, Thomas Edison, Marie Curie.
*   **Theme**: Rapid technological change vs. Tradition.

## 3. Implementation Checklist
- [ ] Clean up `characters.json` (Remove Q-id entries).
- [ ] Create `unified_silla_data.dart` and update `era_data.dart`.
- [ ] Draft prompts for new character images (Jang Bogo, An Jung-geun, etc.).
- [ ] Write detailed biographies and dialogue scripts for new figures.
- [ ] Generate encyclopedia entries and quizzes for new content.
