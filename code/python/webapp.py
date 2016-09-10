# KAFKA_BROKER=localhost:9092 FLASK_PORT=4848 python webapp.py &

from os                   import getenv
from uuid                 import uuid1
from pykafka              import KafkaClient as KC
from pykafka.partitioners import hashing_partitioner
from flask                import ( render_template as rt
                                 , Flask
                                 , request
                                 , redirect
                                 , session
                                 )

POSSIBLE_SIGNALS = \
    [ 'aaa'
    , 'aaaa'
    , 'aaaaa'
    , 'aaaaaa'
    , 'bbb'
    , 'bbbb'
    , 'bbbbb'
    , 'bbbbbb'
    , 'ccc'
    , 'cccc'
    , 'ccccc'
    , 'cccccc'
    , 'ddd'
    , 'dddd'
    , 'ddddd'
    , 'dddddd'
    , 'eee'
    , 'eeee'
    , 'eeeee'
    , 'eeeeee'
    ]

POSSIBLE_SIGNALS_AS_SET = set(POSSIBLE_SIGNALS)

app = Flask(__name__)

@app.route('/')
def home():
    return rt( 'buttons.html'
             , button_pressed=session.get('BUTTON_PRESSED') )

@app.route('/processinput', methods=['POST'])
def processinput():
    buttons_pressed_as_list = list( request.form )
    if len(buttons_pressed_as_list) == 1:
        button_pressed = buttons_pressed_as_list[0]
        if button_pressed in POSSIBLE_SIGNALS_AS_SET:
            session['BUTTON_PRESSED'] = button_pressed
            app.config['PRODUCER'] \
               .produce( '1', partition_key=button_pressed )
    return redirect('/')

if __name__ == '__main__':
    kafka_broker = getenv('KAFKA_BROKER', 'localhost:9092')
    kafka_client = KC(hosts=kafka_broker)
    test_topic = kafka_client.topics['raw']
    app.config['PRODUCER'] = \
        test_topic.get_sync_producer(partitioner=hashing_partitioner)
    app.config['SECRET_KEY'] = getenv( 'SECRET_SESSION_KEY'
                                     , str( uuid1() ) )
    flask_port = int( getenv('FLASK_PORT') )
    app.run(host='0.0.0.0', port=flask_port)
