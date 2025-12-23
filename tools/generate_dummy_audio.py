#!/usr/bin/env python3
"""
더미/테스트용 오디오 파일 생성 스크립트

이 스크립트는 개발 및 테스트 목적으로 사용할 수 있는
더미 오디오 파일(사인파 톤)을 생성합니다.

사용법:
    python3 tools/generate_dummy_audio.py

생성되는 파일:
    - assets/audio/bgm/*.mp3 (배경음악)
    - assets/audio/sfx/*.mp3 (효과음)

참고:
    - 실제 프로덕션에서는 적절한 라이선스의 음악 파일로 교체해야 합니다.
    - MP3 변환을 위해 pydub 사용 시 ffmpeg가 필요합니다.
    - ffmpeg가 없으면 WAV 파일로 생성됩니다.
"""

import os
import wave
import struct
import math
import subprocess
import shutil
from pathlib import Path

# 프로젝트 루트 디렉토리
PROJECT_ROOT = Path(__file__).parent.parent
BGM_DIR = PROJECT_ROOT / "assets" / "audio" / "bgm"
SFX_DIR = PROJECT_ROOT / "assets" / "audio" / "sfx"

# 오디오 설정
SAMPLE_RATE = 44100  # Hz
CHANNELS = 2  # 스테레오
SAMPLE_WIDTH = 2  # 16-bit

# BGM 파일 정의 (파일명, 길이(초), 주파수(Hz), 설명)
BGM_FILES = [
    ("main_menu.mp3", 30, 220, "메인 메뉴 BGM - A3 음"),
    ("world_map.mp3", 30, 261.63, "월드맵 BGM - C4 음"),
    ("dialogue.mp3", 30, 196, "대화 장면 BGM - G3 음"),
    ("quiz.mp3", 20, 329.63, "퀴즈 BGM - E4 음"),
    ("encyclopedia.mp3", 30, 293.66, "도감 BGM - D4 음"),
    ("victory.mp3", 10, 392, "승리 BGM - G4 음"),
    ("era_joseon.mp3", 30, 246.94, "조선 시대 BGM - B3 음"),
    ("era_three_kingdoms.mp3", 30, 277.18, "삼국시대 BGM - C#4 음"),
    ("era_goryeo.mp3", 30, 233.08, "고려 시대 BGM - Bb3 음"),
    ("era_gaya.mp3", 30, 207.65, "가야 시대 BGM - Ab3 음"),
    ("era_renaissance.mp3", 30, 311.13, "르네상스 BGM - Eb4 음"),
]

# SFX 파일 정의 (파일명, 길이(초), 주파수(Hz), 설명)
SFX_FILES = [
    ("button_click.mp3", 0.2, 800, "버튼 클릭음"),
    ("dialogue_advance.mp3", 0.15, 600, "대화 진행음"),
    ("quiz_correct.mp3", 0.5, 523.25, "퀴즈 정답음 - C5 음"),
    ("quiz_wrong.mp3", 0.5, 200, "퀴즈 오답음 - 낮은 음"),
    ("unlock.mp3", 0.8, 659.25, "잠금해제음 - E5 음"),
    ("discovery.mp3", 0.6, 783.99, "발견음 - G5 음"),
    ("level_up.mp3", 1.0, 880, "레벨업음 - A5 음"),
    ("coin_collect.mp3", 0.3, 1046.50, "코인 획득음 - C6 음"),
]


def generate_sine_wave(frequency, duration, volume=0.3, fade_in=0.1, fade_out=0.1):
    """
    사인파를 생성합니다.
    
    Args:
        frequency: 주파수 (Hz)
        duration: 길이 (초)
        volume: 볼륨 (0.0 ~ 1.0)
        fade_in: 페이드 인 시간 (초)
        fade_out: 페이드 아웃 시간 (초)
    
    Returns:
        바이트 데이터
    """
    num_samples = int(SAMPLE_RATE * duration)
    fade_in_samples = int(SAMPLE_RATE * min(fade_in, duration / 2))
    fade_out_samples = int(SAMPLE_RATE * min(fade_out, duration / 2))
    
    samples = []
    
    for i in range(num_samples):
        # 기본 사인파
        t = i / SAMPLE_RATE
        value = math.sin(2 * math.pi * frequency * t)
        
        # 약간의 하모닉 추가 (더 풍부한 소리)
        value += 0.3 * math.sin(4 * math.pi * frequency * t)  # 2nd harmonic
        value += 0.1 * math.sin(6 * math.pi * frequency * t)  # 3rd harmonic
        
        # 정규화
        value = value / 1.4
        
        # 페이드 인/아웃 적용
        if i < fade_in_samples:
            value *= i / fade_in_samples
        elif i > num_samples - fade_out_samples:
            value *= (num_samples - i) / fade_out_samples
        
        # 볼륨 적용
        value *= volume
        
        # 16-bit 정수로 변환
        sample = int(value * 32767)
        sample = max(-32768, min(32767, sample))
        
        # 스테레오 (좌/우 동일)
        samples.append(sample)
        samples.append(sample)
    
    return struct.pack('<' + 'h' * len(samples), *samples)


def generate_sfx_wave(frequency, duration, volume=0.5):
    """
    효과음용 사인파를 생성합니다 (빠른 페이드).
    """
    return generate_sine_wave(
        frequency, 
        duration, 
        volume=volume,
        fade_in=0.02,
        fade_out=duration * 0.3
    )


def create_wav_file(filepath, audio_data):
    """
    WAV 파일을 생성합니다.
    """
    with wave.open(str(filepath), 'w') as wav_file:
        wav_file.setnchannels(CHANNELS)
        wav_file.setsampwidth(SAMPLE_WIDTH)
        wav_file.setframerate(SAMPLE_RATE)
        wav_file.writeframes(audio_data)


def convert_wav_to_mp3(wav_path, mp3_path):
    """
    WAV 파일을 MP3로 변환합니다.
    ffmpeg가 필요합니다.
    """
    # ffmpeg 확인
    if shutil.which('ffmpeg') is None:
        print("  ⚠️  ffmpeg가 설치되어 있지 않습니다. WAV 파일을 유지합니다.")
        return False
    
    try:
        subprocess.run([
            'ffmpeg', '-y', '-i', str(wav_path),
            '-codec:a', 'libmp3lame', '-qscale:a', '2',
            str(mp3_path)
        ], check=True, capture_output=True)
        
        # 변환 성공 시 WAV 파일 삭제
        os.remove(wav_path)
        return True
    except subprocess.CalledProcessError as e:
        print(f"  ⚠️  MP3 변환 실패: {e}")
        return False


def generate_audio_files(directory, files, is_sfx=False):
    """
    오디오 파일들을 생성합니다.
    """
    # 디렉토리 생성
    directory.mkdir(parents=True, exist_ok=True)
    
    for filename, duration, frequency, description in files:
        print(f"  📝 생성 중: {filename} ({description})")
        
        # 파일 경로
        base_name = filename.rsplit('.', 1)[0]
        wav_path = directory / f"{base_name}.wav"
        mp3_path = directory / filename
        
        # 오디오 데이터 생성
        if is_sfx:
            audio_data = generate_sfx_wave(frequency, duration)
        else:
            audio_data = generate_sine_wave(frequency, duration)
        
        # WAV 파일 생성
        create_wav_file(wav_path, audio_data)
        
        # MP3로 변환 시도
        if not convert_wav_to_mp3(wav_path, mp3_path):
            # 변환 실패 시 WAV 파일명을 MP3로 변경
            # (Flutter의 flame_audio는 확장자로 판단하지 않음)
            final_path = directory / filename.replace('.mp3', '.wav')
            if wav_path != final_path:
                shutil.move(wav_path, final_path)
            print(f"     → WAV로 저장됨: {final_path.name}")
        else:
            print(f"     ✓ MP3로 저장됨: {mp3_path.name}")


def check_flutter_audio_support():
    """
    Flutter flame_audio가 WAV 파일도 지원하는지 안내합니다.
    """
    print("""
💡 참고사항:
   - flame_audio는 MP3, OGG, WAV 등 다양한 포맷을 지원합니다.
   - ffmpeg가 없어서 WAV 파일이 생성된 경우에도 앱에서 재생 가능합니다.
   - 실제 배포 시에는 파일 크기를 위해 MP3 또는 OGG로 변환하는 것을 권장합니다.
""")


def update_audio_constants_if_needed():
    """
    WAV 파일이 생성된 경우 audio_constants.dart 파일을 업데이트할지 안내합니다.
    """
    # WAV 파일이 있는지 확인
    wav_files = list(BGM_DIR.glob("*.wav")) + list(SFX_DIR.glob("*.wav"))
    
    if wav_files:
        print("""
⚠️  WAV 파일이 생성되었습니다.
    audio_constants.dart의 파일 확장자를 .wav로 변경하거나,
    ffmpeg를 설치 후 다시 스크립트를 실행하세요.
    
    ffmpeg 설치 (macOS):
        brew install ffmpeg
""")


def print_summary():
    """
    생성된 파일 목록을 출력합니다.
    """
    print("\n" + "=" * 60)
    print("📁 생성된 BGM 파일:")
    for f in sorted(BGM_DIR.glob("*")):
        if f.name != ".gitkeep":
            size_kb = f.stat().st_size / 1024
            print(f"   • {f.name} ({size_kb:.1f} KB)")
    
    print("\n📁 생성된 SFX 파일:")
    for f in sorted(SFX_DIR.glob("*")):
        if f.name != ".gitkeep":
            size_kb = f.stat().st_size / 1024
            print(f"   • {f.name} ({size_kb:.1f} KB)")
    
    print("=" * 60)


def main():
    print("=" * 60)
    print("🎵 TimeWalker 더미 오디오 파일 생성 스크립트")
    print("=" * 60)
    print()
    
    # BGM 파일 생성
    print("🎶 BGM 파일 생성 중...")
    generate_audio_files(BGM_DIR, BGM_FILES, is_sfx=False)
    print()
    
    # SFX 파일 생성
    print("🔔 SFX 파일 생성 중...")
    generate_audio_files(SFX_DIR, SFX_FILES, is_sfx=True)
    
    # 요약 출력
    print_summary()
    
    # 추가 안내
    check_flutter_audio_support()
    update_audio_constants_if_needed()
    
    print("✅ 더미 오디오 파일 생성 완료!")
    print()


if __name__ == "__main__":
    main()
