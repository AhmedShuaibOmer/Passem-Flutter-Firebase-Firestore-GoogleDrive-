/*
 * Created Date: 2/19/21 11:47 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

const String usersPath = 'users';

const String universitiesPath = 'universities';

String collegesPath(String universityId) =>
    '$universitiesPath/$universityId/colleges';

String coursesPath(String universityId, String collegesId) =>
    '${collegesPath(universityId)}/$collegesId/courses';

String studyMaterialsPath(String universityId, String collegesId) =>
    '${collegesPath(universityId)}/$collegesId/studyMaterials';
