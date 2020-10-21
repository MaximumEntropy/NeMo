pip install -r requirements/requirements.txt \
  && pip install -r requirements/requirements_nlp.txt \
  && export nemo_path=$(pwd) \
  && export HYDRA_FULL_ERROR=1 \
  && echo "NeMo path: ${nemo_path}" \
  && export PYTHONPATH="${nemo_path}" \
  && mkdir -p /data \
  && cd /data \
  && wget https://nlp.stanford.edu/projects/nmt/data/wmt14.en-de/newstest2013.de -O valid.de \
  && wget https://nlp.stanford.edu/projects/nmt/data/wmt14.en-de/newstest2013.en -O valid.en \
  && wget https://nlp.stanford.edu/projects/nmt/data/wmt14.en-de/newstest2014.de -O test.de \
  && wget https://nlp.stanford.edu/projects/nmt/data/wmt14.en-de/newstest2014.en -O test.en \
  && wget https://nlp.stanford.edu/projects/nmt/data/wmt14.en-de/train.de \
  && wget https://nlp.stanford.edu/projects/nmt/data/wmt14.en-de/train.en \
  && cat train.en train.de > yttm_train.ende \
  && echo "current path when creating yttm model: $(pwd)" \
  && yttm bpe --data yttm_train.ende --model bpe_37k_en_de_yttm.model --vocab_size 37000 \
  && cd  "${nemo_path}/examples/nlp/machine_translation" \
  && python train.py -cn de_en_8gpu \
  && export best_ckpt_path=$(cat best_checkpoint_path.txt) \
  && echo "best ckpt path:" ${best_ckpt_path} \
  && ln -s ${best_ckpt_path} best.ckpt \
  && python test.py model.test_checkpoint_path=best.ckpt -cn de_en_8gpu

