ristretto --display=:0 -f /home/tugdual/1.jpg &
cd /home/tugdual
aplay boop.wav

sudo -u tugdual whisper.cpp/main -m ggml-base.en.bin -otxt -of test -t 8 recording.wav &
whisper_pid=$!

# Wait for whisper processing to finish
wait $whisper_pid

grep -v -e "\(speaking in foreign language\)" -e "\[BLANK_AUDIO\]" -e "\(silence\)" test.txt > out.txt

cat header.txt out.txt footer.txt > outhf.txt

sudo -u tugdual ./llama.cpp/llama-cli -m qwen2-7b-instruct-q2_k.gguf -v -co -f outhf.txt -fa -n 30 --no-display-prompt 2>/dev/null > out2.txt
killall ristretto &
kill_pid=$!
wait $kill_pid

ristretto --display=:0 -f /home/tugdual/2.jpg &
sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' out2.txt > cleaned_output.txt
cat cleaned_output.txt | espeak -ven+f2 -k6 -s150 -a 50 -g10 --stdout | aplay
killall ristretto &
kill_pid=$!
wait $kill_pid
ristretto --display=:0 -f /home/tugdual/3.jpg &