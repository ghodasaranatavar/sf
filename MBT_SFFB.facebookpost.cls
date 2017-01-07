global class facebookpost {
global facebookpost()
{
}
    global static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    global class Data_Y {
        global String id {get;set;} 
        global String permalink_url {get;set;} 
        global String message {get;set;} 
        global String type_Z {get;set;} // in json: type
        global String created_time {get;set;} 
        global From_Y from_Y {get;set;} // in json: from
        global Likes likes {get;set;} 
        global Comments comments {get;set;} 
        global String picture {get;set;} 

        global Data_Y(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'permalink_url') {
                            permalink_url = parser.getText();
                        } else if (text == 'message') {
                            message = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'created_time') {
                            created_time = parser.getText();
                        } else if (text == 'from') {
                            from_Y = new From_Y(parser);
                        } else if (text == 'likes') {
                            likes = new Likes(parser);
                        } else if (text == 'comments') {
                            comments = new Comments(parser);
                        }
                         else if (text == 'picture') {
                            picture = parser.getText();
                        }  
                        else {
                            System.debug(LoggingLevel.WARN, 'Data_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Data_Z {
        global String id {get;set;} 
        global String message {get;set;} 
        global Integer comment_count {get;set;} 
        global String created_time {get;set;} 
        global From_Z from_Z {get;set;} // in json: from
        global Integer like_count {get;set;} 

        global Data_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'message') {
                            message = parser.getText();
                        } else if (text == 'comment_count') {
                            comment_count = parser.getIntegerValue();
                        } else if (text == 'created_time') {
                            created_time = parser.getText();
                        } else if (text == 'from') {
                            from_Z = new From_Z(parser);
                        } else if (text == 'like_count') {
                            like_count = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global String id {get;set;} 
    global String name {get;set;} 
    global Feed feed {get;set;} 

    global facebookpost(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'id') {
                        id = parser.getText();
                    } else if (text == 'name') {
                        name = parser.getText();
                    } else if (text == 'feed') {
                        feed = new Feed(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    global class Comments {
        global List<Data_Z> data {get;set;} 
        global Paging paging {get;set;} 

        global Comments(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'data') {
                            data = new List<Data_Z>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                data.add(new Data_Z(parser));
                            }
                        } else if (text == 'paging') {
                            paging = new Paging(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Comments consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Paging {
        global Cursors cursors {get;set;} 

        global Paging(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'cursors') {
                            cursors = new Cursors(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Paging consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class From_Z {
        global String name {get;set;} 
        global String id {get;set;} 

        global From_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'From_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class From_Y {
        global String name {get;set;} 
        global String id {get;set;} 

        global From_Y(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'From_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Cursors {
        global String before {get;set;} 
        global String after {get;set;} 

        global Cursors(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'before') {
                            before = parser.getText();
                        } else if (text == 'after') {
                            after = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Cursors consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Data {
        global String id {get;set;} 
        global String name {get;set;} 
        global String pic {get;set;} 
        global String profile_type {get;set;} 
        global String link {get;set;} 
        global String username {get;set;} 

        global Data(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'pic') {
                            pic = parser.getText();
                        } else if (text == 'profile_type') {
                            profile_type = parser.getText();
                        } else if (text == 'link') {
                            link = parser.getText();
                        } else if (text == 'username') {
                            username = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Likes {
        global List<Data> data {get;set;} 
        global Paging paging {get;set;} 

        global Likes(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'data') {
                            data = new List<Data>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                data.add(new Data(parser));
                            }
                        } else if (text == 'paging') {
                            paging = new Paging(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Likes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Paging_Z {
        global String previous {get;set;} 
        global String next {get;set;} 

        global Paging_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'previous') {
                            previous = parser.getText();
                        } else if (text == 'next') {
                            next = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Paging_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Feed {
        global List<Data_Y> data {get;set;} 
        global Paging_Z paging {get;set;} 

        global Feed(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'data') {
                            data = new List<Data_Y>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                data.add(new Data_Y(parser));
                            }
                        } else if (text == 'paging') {
                            paging = new Paging_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Feed consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    global static facebookpost parse(String json) {
        return new facebookpost(System.JSON.createParser(json));
    }
}