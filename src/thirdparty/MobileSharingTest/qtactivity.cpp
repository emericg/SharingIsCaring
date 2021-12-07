namespace
{
QMutex sInstanceMutex;
StorageWrapper* sInstance(nullptr);

void indExportData(JNIEnv* /*env*/, jobject /*object*/, jboolean success)
{
    QMutexLocker instanceLocker(&sInstanceMutex);
    if(sInstance) {
        QMetaObject::invokeMethod(sInstance, "indExportData", Qt::QueuedConnection, Q_ARG(bool, success));
    }
}

void indImportData(JNIEnv* /*env*/, jobject /*object*/, jbyteArray byteArray, jboolean success)
{
    QAndroidJniEnvironment env;
    const jsize arrayLength = env->GetArrayLength(byteArray);

    QJsonObject jsonObject;
    if(arrayLength > 0) {
        jbyte* bytePtr = env->GetByteArrayElements(byteArray, nullptr);
        jsonObject = QJsonDocument::fromJson(QByteArray(reinterpret_cast<char*>(bytePtr), arrayLength)).object();
        env->ReleaseByteArrayElements(byteArray, bytePtr, JNI_ABORT);
    }

    QMutexLocker instanceLocker(&sInstanceMutex);
    if(sInstance) {
        QMetaObject::invokeMethod(sInstance, "indImportData", Qt::QueuedConnection, Q_ARG(QJsonObject, jsonObject), Q_ARG(bool, success));
    }
}

const JNINativeMethod jniMethods[] = {
    { "indExportData", "(Z)V", reinterpret_cast<void*>(&indExportData) },
    { "indImportData", "([BZ)V", reinterpret_cast<void*>(indImportData) }
};
} // namespace

StorageWrapper::StorageWrapper(QObject* parent)
    : QObject(parent)
{
    QAndroidJniEnvironment jniEnv;
    jniEnv->RegisterNatives(jniEnv->GetObjectClass(QtAndroid::androidActivity().object()), jniMethods, sizeof(jniMethods) / sizeof(jniMethods[0]));

    QMutexLocker instanceLocker(&sInstanceMutex);
    sInstance = this;
}

StorageWrapper::~StorageWrapper()
{
    QAndroidJniEnvironment jniEnv;
    jniEnv->UnregisterNatives(jniEnv->GetObjectClass(QtAndroid::androidActivity().object()));

    QMutexLocker instanceLocker(&sInstanceMutex);
    sInstance = nullptr;
}

void StorageWrapper::reqExportData(const QJsonObject& jsonObject)
{
    const QAndroidJniObject activity(QtAndroid::androidActivity());
    if(activity.isValid()) {
        const QByteArray json(QJsonDocument(jsonObject).toJson(QJsonDocument::Compact));

        QAndroidJniEnvironment env;
        jbyteArray byteArray = env->NewByteArray(json.length());
        env->SetByteArrayRegion(byteArray, 0, json.length(), reinterpret_cast<const jbyte*>(json.constData()));

        activity.callMethod<void>("reqExportData",
                                  "([B)V",
                                  byteArray);

        env->DeleteLocalRef(byteArray);
    }
}

void StorageWrapper::reqImportData()
{
    const QAndroidJniObject activity(QtAndroid::androidActivity());
    if(activity.isValid()) {
        activity.callMethod<void>("reqImportData",
                                  "()V");
    }
}
