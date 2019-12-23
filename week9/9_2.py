# -*- coding: utf-8 -*-

from keras.models import Model
from keras import layers
from keras.layers import Input, Dense
from keras.utils import plot_model

import numpy as np
import string
import re,sys



class Model1:
    def __init__(self, path):
        self.characters = sorted(string.printable)
        self.char_indices = dict((c, i) for i, c in enumerate(self.characters))
        self.indices_char = dict((i, c) for i, c in enumerate(self.characters))

        self.INPUT_VOCAB_SIZE = len(self.characters)
        self.LINE_SIZE = max(map(lambda x: len(x), open(path).readlines()))
        self.model = self.build_model()

    def encode_one_hot(self, s):
        """One-hot encode all characters of the given string.
        """
        all = []
        for c in s:
            x = np.zeros((self.INPUT_VOCAB_SIZE))
            index = self.char_indices[c]
            x[index] = 1
            all.append(x)
        return all

    def decode_one_hot(self, x):
        """Return a string from a one-hot-encoded matrix
        """
        s = []
        for onehot in x:
            # one_index is a tuple of two things
            one_index = np.where(onehot == 1)
            if len(one_index[0]) > 0:
                n = one_index[0][0]
                c = self.indices_char[n]
                s.append(c)
        return ''.join(s)

    def normalization_layer_set_weights(self, n_layer):
        wb = []
        b = np.zeros((self.INPUT_VOCAB_SIZE), dtype=np.float32)
        w = np.zeros(
            (self.INPUT_VOCAB_SIZE, self.INPUT_VOCAB_SIZE), dtype=np.float32)
        # Let lower case letters go through
        for c in string.ascii_lowercase:
            i = self.char_indices[c]
            w[i, i] = 1
        # Map capitals to lower case
        for c in string.ascii_uppercase:
            i = self.char_indices[c]
            il = self.char_indices[c.lower()]
            w[i, il] = 1
        # Map all non-letters to space
        sp_idx = self.char_indices[' ']
        for c in [c for c in list(string.printable) if c not in list(string.ascii_letters)]:
            i = self.char_indices[c]
            w[i, sp_idx] = 1

        wb.append(w)
        wb.append(b)
        n_layer.set_weights(wb)
        return n_layer

    def build_model(self):
        print('Build model...')

        # Normalize every character in the input, using a shared dense model
        n_layer = Dense(self.INPUT_VOCAB_SIZE)
        raw_inputs = []
        normalized_outputs = []
        for _ in range(0, self.LINE_SIZE):
            input_char = Input(shape=(self.INPUT_VOCAB_SIZE, ))
            filtered_char = n_layer(input_char)
            raw_inputs.append(input_char)
            normalized_outputs.append(filtered_char)
        self.normalization_layer_set_weights(n_layer)

        merged_output = layers.concatenate(normalized_outputs, axis=-1)

        reshape = layers.Reshape((self.LINE_SIZE, self.INPUT_VOCAB_SIZE, ))
        reshaped_output = reshape(merged_output)

        model = Model(inputs=raw_inputs, outputs=reshaped_output)

        return model

    def predict(self, line):
        onehots = self.encode_one_hot(line)
        data = [[] for _ in range(self.LINE_SIZE)]
        for i, c in enumerate(onehots):
            data[i].append(c)
        for j in range(len(onehots), self.LINE_SIZE):
            data[j].append(np.zeros((self.INPUT_VOCAB_SIZE)))
        inputs = [np.array(e) for e in data]
        preds = self.model.predict(inputs)
        normal = self.decode_one_hot(preds[0])
        return normal


class Model2:
    def __init__(self, path):
        stopwords = set(open('../stop_words.txt').read().split(',')) | set(list(string.ascii_lowercase))
        all_words = re.findall('[a-z]{2,}', open(path).read().lower())

        self.stoplist = list(stopwords)
        self.uniqs = [''] + list(set(all_words) | stopwords)
        self.uniqs_indices = dict((w, i) for i, w in enumerate(self.uniqs))
        self.indices_uniqs = dict((i, w) for i, w in enumerate(self.uniqs))
        self.indices = [self.uniqs_indices[w] for w in all_words]

        self.WORDS_SIZE = len(all_words)
        self.VOCAB_SIZE = len(self.uniqs)
        self.LINE_SIZE = max(map(lambda x: len(
            [w for w in x.split(" ") if w]), open(path).readlines()))  # 20 words
        self.model = self.build_model()
    # BIN_SIZE = math.ceil(math.log(VOCAB_SIZE, 2))

    def encode_one_hot(self, s):
        """One-hot encode all characters of the given string.
        """
        all = []
        for w in s:
            x = np.zeros((self.VOCAB_SIZE))
            index = self.uniqs_indices[w]
            x[index] = 1
            all.append(x)
        return all

    def decode_one_hot(self, x):
        """Return a string from a one-hot-encoded matrix
        """
        s = []
        for onehot in x:
            # one_index is a tuple of two things
            one_index = np.where(onehot == 1)
            if len(one_index[0]) > 0:
                n = one_index[0][0]
                w = self.indices_uniqs[n]
                s.append(w)
        return ' '.join(s)

    def set_weights(self, n_layer):
        wb = []
        b = np.zeros((self.VOCAB_SIZE), dtype=np.float32)
        w = np.zeros((self.VOCAB_SIZE, self.VOCAB_SIZE), dtype=np.float32)

        for word in self.uniqs:
            if word in self.stoplist:
                il = self.uniqs_indices['']
            else:
                il = self.uniqs_indices[word]
            i = self.uniqs_indices[word]
            w[i, il] = 1

        wb.append(w)
        wb.append(b)
        n_layer.set_weights(wb)
        return n_layer

    def build_model(self):
        print('Build model...')

        # Normalize every character in the input, using a shared dense model
        n_layer = Dense(self.VOCAB_SIZE)
        raw_inputs = []
        normalized_outputs = []
        for _ in range(0, self.LINE_SIZE):
            input_word = Input(shape=(self.VOCAB_SIZE,))
            filtered_char = n_layer(input_word)
            raw_inputs.append(input_word)
            normalized_outputs.append(filtered_char)
        self.set_weights(n_layer)
        merged_output = layers.concatenate(normalized_outputs, axis=-1)
        reshape = layers.Reshape((self.LINE_SIZE, self.VOCAB_SIZE,))
        reshaped_output = reshape(merged_output)
        model = Model(inputs=raw_inputs, outputs=reshaped_output)

        return model

    def predict(self, words):
        onehots = self.encode_one_hot([w for w in words.split(" ") if w])
        data = [[] for _ in range(self.LINE_SIZE)]
        for i, c in enumerate(onehots):
            data[i].append(c)
        for j in range(len(onehots), self.LINE_SIZE):
            data[j].append(np.zeros((self.VOCAB_SIZE)))

        inputs = [np.array(e) for e in data]
        preds = self.model.predict(inputs)
        normal = self.decode_one_hot(preds[0])
        return normal

FILE = sys.argv[1]
m1 = Model1(FILE)
# model.summary()
m2 = Model2(FILE)
# plot_model(model, to_file='normalization.png', show_shapes=True)
with open(FILE, encoding='utf-8-sig') as f:
    for line in f:
        if line.isspace():
            continue
        if len(re.findall('[a-z]{2,}', line)) == 0:
            continue
        print(m2.predict(m1.predict(line)))
