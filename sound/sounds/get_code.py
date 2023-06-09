import pydub
import pickle

with open('bud_last.wav', 'rb') as f:
    data = pydub.AudioSegment(f).export(format = 'raw').read()

counter = 0
zeros  = "00000000"
with open('mus.bin', 'w') as f2:
    for i in range(len(data)):
        temp = format(data[i], 'b')
        if len(temp) != 8:
            temp = zeros[:(8-len(temp))] + temp
        f2.write(temp)
        #f2.write("\n")
        if counter == 3:
            f2.write("\n")
            counter = 0
        else:
            counter+=1

# with open('m1.txt', 'wb') as f2:
#     for i in range(len(data)):
#         pickle.dump(data[i], f2)
#         f2.write("\n")67