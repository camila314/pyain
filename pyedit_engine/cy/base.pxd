#cython: language_level=3
from libcpp.string cimport string
from libcpp cimport bool

cdef extern from "extra_bindings.h":
    struct event_base:
        string name
    struct add_object_event:
        string name
        int object_id

    struct CCPoint:
        float x
        float y

    cppclass CCObject:
        void retain()
        void release()

    cppclass CCNode:
        void setPosition(CCPoint pt)
        CCPoint getPosition()
        void setRotation(float)
        float getRotation()
        void setScale(float)
        float getScale()
    cppclass CCArray(CCObject):
        @staticmethod
        CCArray* create()
        int count()
        CCObject* objectAtIndex(unsigned int)
        void addObject(CCObject*)

    EditorUI* EditorUI_shared()
    bool onMainThread()
    long makeUsable(void*)
    CCPoint getMouseCoords()
    char* getNode(CCObject*)
    event_base* popEvent()

    cppclass LevelEditorLayer:
        GameObject* createObject(int, CCPoint, bool)
        CCArray* _objects()

    cppclass EditorUI:
        void selectObjects(CCArray*, bool)
        void pasteObjects(string)
        void onDuplicate(CCObject*)
        CCArray* getSelectedObjects()
        void deselectAll()
        LevelEditorLayer* _editorLayer()

    cppclass GameObject(CCNode):
        int _id()
        void destroyObject()
        string getSaveString()
        void updateCustomScale(float)
        @staticmethod
        GameObject* createWithKey(int k)
        int& _zOrder()

    cppclass ThreadController:
        @staticmethod
        ThreadController* sharedState()
        bool schedulePy(object p)

cdef inline mainThread(object o):
    ThreadController.sharedState().schedulePy(o)