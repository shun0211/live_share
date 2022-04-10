FROM ruby:2.7.1

# Debianのインストール
# no valud opengpg data found. segmentation fault
# https://zenn.dev/junki555/articles/2de6024a191913
RUN set -x \
    && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# rails6.0からJavaScriptコンパイラがwebpackerに変更され、webpackerの導入に必要なパッケージマネージャであるyarnをインストールする
RUN set -x \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y \
    build-essential \
    nodejs \
    sudo \
    yarn \
    imagemagick \
    mariadb-client \
    vim \
  && rm -rf /var/lib/apt/lists/*


# M1Macでchromeのインストールができないようなのでいったんコメントアウト
# chromeの追加
# RUN apt-get update && apt-get install -y unzip && \
#     CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
#     wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
#     unzip ~/chromedriver_linux64.zip -d ~/ && \
#     rm ~/chromedriver_linux64.zip && \
#     chown root:root ~/chromedriver && \
#     chmod 755 ~/chromedriver && \
#     mv ~/chromedriver /usr/bin/chromedriver && \
#     sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
#     sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
#     apt-get update && apt-get install -y google-chrome-stable

RUN set -x && gem install bundler

RUN mkdir /myapp
WORKDIR /myapp

RUN set -x && mkdir log && mkdir -p tmp/pids

COPY package.json .
COPY yarn.lock .
RUN set -x && yarn install --frozen-lockfile

COPY Gemfile .
COPY Gemfile.lock .
RUN set -x && bundle install --jobs=4
COPY . .
# COPY .ssh /root/.ssh

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
