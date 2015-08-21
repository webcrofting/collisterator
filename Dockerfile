
FROM rails

EXPOSE 3000

RUN addgroup --gid 1000 rails
RUN useradd --uid 1000 --gid 1000 --home-dir /usr/src/app rails

WORKDIR /usr/src/app
CMD rails s -b 0.0.0.0

COPY ./Gemfile* /usr/src/app/
RUN bundle install --system
RUN mkdir -p /opt/rde
RUN cp Gemfile.lock /opt/rde

