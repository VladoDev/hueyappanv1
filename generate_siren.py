import wave
import math
import struct

sample_rate = 44100
duration = 30.0
# frequencies for a European style police siren (high-low alternating)
freq_high = 900.0
freq_low = 600.0
cycle_duration = 0.5 # 0.5s high, 0.5s low

with wave.open('siren.wav', 'w') as wav_file:
    wav_file.setnchannels(1)
    wav_file.setsampwidth(2)
    wav_file.setframerate(sample_rate)

    total_samples = int(sample_rate * duration)
    for i in range(total_samples):
        t = i / sample_rate
        # Determine current frequency
        if (t % cycle_duration) < (cycle_duration / 2):
            freq = freq_high
        else:
            freq = freq_low
        
        # Sine wave
        value = int(32767.0 * math.sin(2.0 * math.pi * freq * t))
        data = struct.pack('<h', value)
        wav_file.writeframesraw(data)

print("Generated siren.wav")
