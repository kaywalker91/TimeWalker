#!/bin/bash
# WAV to MP3 Conversion Script
# 더미 WAV 오디오 파일을 MP3로 변환합니다.

set -e

echo "============================================================"
echo "🎵 WAV -> MP3 변환 스크립트"
echo "============================================================"
echo ""

# 프로젝트 루트 디렉토리
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BGM_DIR="$PROJECT_ROOT/assets/audio/bgm"
SFX_DIR="$PROJECT_ROOT/assets/audio/sfx"

# ffmpeg 확인
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ ffmpeg가 설치되어 있지 않습니다."
    echo "   설치: brew install ffmpeg"
    exit 1
fi

echo "✓ ffmpeg 확인 완료"
echo ""

# 변환 함수
convert_wav_to_mp3() {
    local dir=$1
    local dir_name=$2
    
    echo "📁 $dir_name 폴더 변환 중..."
    
    # .wav 파일 찾기
    shopt -s nullglob
    wav_files=("$dir"/*.wav)
    
    if [ ${#wav_files[@]} -eq 0 ]; then
        echo "   ⚠️  WAV 파일이 없습니다."
        return
    fi
    
    for wav_file in "${wav_files[@]}"; do
        # 파일명 추출
        filename=$(basename "$wav_file" .wav)
        mp3_file="$dir/${filename}.mp3"
        
        echo "   📝 변환 중: ${filename}.wav -> ${filename}.mp3"
        
        # ffmpeg로 변환 (고품질 VBR)
        ffmpeg -y -i "$wav_file" \
            -codec:a libmp3lame \
            -qscale:a 2 \
            -ar 44100 \
            -ac 2 \
            "$mp3_file" \
            -loglevel error
        
        # 변환 성공 시 WAV 파일 삭제
        if [ -f "$mp3_file" ]; then
            rm "$wav_file"
            
            # 파일 크기 비교 (이제 WAV가 없으므로 MP3 크기만 표시)
            mp3_size=$(du -h "$mp3_file" | cut -f1)
            echo "      ✓ 완료: $mp3_size"
        else
            echo "      ❌ 변환 실패"
        fi
    done
    echo ""
}

# BGM 변환
convert_wav_to_mp3 "$BGM_DIR" "BGM"

# SFX 변환
convert_wav_to_mp3 "$SFX_DIR" "SFX"

# 결과 요약
echo "============================================================"
echo "📊 변환 결과:"
echo ""

echo "📁 BGM 파일:"
for f in "$BGM_DIR"/*.mp3; do
    if [ -f "$f" ]; then
        size=$(du -h "$f" | cut -f1)
        echo "   • $(basename "$f"): $size"
    fi
done

echo ""
echo "📁 SFX 파일:"
for f in "$SFX_DIR"/*.mp3; do
    if [ -f "$f" ]; then
        size=$(du -h "$f" | cut -f1)
        echo "   • $(basename "$f"): $size"
    fi
done

echo ""
echo "============================================================"
echo "✅ 변환 완료!"
echo ""
echo "💡 다음 단계:"
echo "   audio_constants.dart의 파일 확장자를 .mp3로 변경하세요."
echo "============================================================"
